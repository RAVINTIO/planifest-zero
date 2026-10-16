# Security Report - 0000035-powershell-setup-parity

**Skill:** planifest-security-agent (P5)
**Scope:** `git diff 40e00ac..HEAD -- planifest-zero/setup.sh planifest-zero/setup.ps1`, plus the unchanged code those changes call
**Method:** static review. No `pwsh` exists on this machine, so PowerShell 5.1 and 7 behaviour comes from knowledge of each runtime, not from a run.

Overall risk rating: **Medium**. One medium finding affects every Windows PowerShell 5.1 run. The other seven findings are low.

## Findings

| ID | Severity | File and line | Finding | Suggested fix |
|----|----------|---------------|---------|---------------|
| S-001 | Medium | `planifest-zero/setup.ps1:280`, `:412`, `:228` | On 5.1, two readers decode `settings.json` as ANSI, and the writer adds a BOM. | Read with `-Encoding UTF8`. Write UTF-8 with no BOM. |
| S-002 | Low | `planifest-zero/setup.ps1:366`, `:226`, `:228` | On 5.1, `Get-Item` may not see a dangling link at the temporary path, so the next write follows it. | Detect the link with an attribute check that does not follow links. |
| S-003 | Low | `planifest-zero/setup.ps1:226`, `:374` | A non-empty folder at the temporary path makes `Remove-Item` prompt. A yes on 5.1 can recurse through a junction. | Refuse a plain folder with a clear error. Delete files through .NET. |
| S-004 | Low | `planifest-zero/setup.ps1:291-297` | The `PreToolUse` filter drops a whole entry on a loose, case-insensitive substring match, on any matcher. | Match `<module>.mjs` at a path boundary with `-cmatch`. |
| S-005 | Low | `planifest-zero/setup.ps1:250` | The hook command leaves the path unquoted. `setup.sh` quotes it. | Quote the path as `setup.sh` does. |
| S-006 | Low | `planifest-zero/setup.ps1:341-350` | `Merge-AllowedTools` differs from `setup.sh` on case, string values, and unreadable files. | Use `-cnotcontains`. Warn and skip the write when parsing fails. |
| S-007 | Low | `planifest-zero/setup.ps1:557` | The `` `u{2705} `` escape needs PowerShell 6 or later. 5.1 prints `u{2705}`. | Use `$([char]0x2705)`. |
| S-008 | Low | `planifest-zero/setup.ps1:37`, `:1106-1108` | `setup.ps1` lowercases the tool name. `setup.sh` matches it by exact case. | Compare the tool name with `-ccontains` and drop `ToLower()`. |

### S-001: 5.1 decodes `settings.json` as ANSI and writes a BOM (Medium)

Category: Tampering (integrity of the enforcement configuration).

- `Merge-EnforcementHookSettings` (line 280) and `Remove-LegacyTelemetryWiring` (line 412) call `Get-Content -Raw` with no `-Encoding`.
- Windows PowerShell 5.1 reads a file with no BOM in the ANSI code page. Claude Code, `setup.sh`, and most editors write UTF-8 with no BOM.
- Any non-ASCII text in the file then decodes wrongly. One example is a permission rule naming `C:\Users\José`.
- `Write-SettingsAtomic` writes the result back as UTF-8, so the damage persists.
- `Set-Content -Encoding UTF8` (line 228) writes a BOM on 5.1 but not on 7. `setup.sh` strips a BOM on read (lines 465 and 515). This review did not confirm that Claude Code accepts a BOM.

`Merge-AllowedTools` (line 340) already passes `-Encoding UTF8`, so the three readers disagree. Lines 280 and 412 predate this diff. This feature now claims 5.1 support in req-003, so the defect is in scope.

Fix: add `-Encoding UTF8` at lines 280 and 412. In `Write-SettingsAtomic`, replace `Set-Content` with `[System.IO.File]::WriteAllText($tmp, $Json, (New-Object System.Text.UTF8Encoding $false))`.

### S-002: a dangling link can escape the 5.1 leftover check (Low)

Category: Tampering. This is the residual of risk register R-005.

- `Remove-LeftoverSettingsTmp` relies on `Get-Item -LiteralPath $tmp -Force` (line 366).
- Windows PowerShell 5.1 checks that the item exists by following the link. On a dangling link, `Get-Item` is likely to report "not found", so the function returns and leaves the link.
- `Write-SettingsAtomic` then calls `Remove-Item` on the same path (line 226) with `SilentlyContinue`, which has the same blind spot.
- `Set-Content` (line 228) opens the path, Windows follows the link, and setup creates the link's target with the settings JSON.

PowerShell 7 handles dangling links in `Get-Item`, so this applies to 5.1 only. A planted link needs write access to `.claude/`. Creating a symlink on Windows also needs Developer Mode or elevation. The req-005 suite plants a link for `setup.sh` only, at line 68, so nothing tests the PowerShell path.

Fix: test for any entry, including a dangling link, with `$fi = New-Object System.IO.FileInfo $tmp` and `[int]$fi.Attributes -ne -1`. `GetFileAttributesEx` does not follow links, so this works on both versions. Use the same check in `Write-SettingsAtomic` before line 226.

### S-003: a planted folder can reach a recursive delete prompt (Low)

Category: Tampering, Denial of Service.

- `Remove-LeftoverSettingsTmp` leaves a plain folder by design (line 373). `Write-SettingsAtomic` then calls `Remove-Item -LiteralPath $tmp -Force` on it (line 226).
- On a non-empty folder without `-Recurse`, `Remove-Item` shows the "has children" confirmation in an interactive host. `-ErrorAction` does not suppress that prompt.
- If the person answers yes, 5.1 recurses. It follows any junction inside the folder into its target, as the comment at line 471 records.
- If the person declines, `Set-Content` fails on the folder and setup stops.
- The same path opens through the race at line 374. An attacker can swap the file for a folder between `Get-Item` and `Remove-Item`.

Both paths need local write access to `.claude/` and a yes at a confusing prompt. `setup.sh` has neither problem. `rm -f` without `-r` fails safely on a folder.

Fix: in both functions, delete a file or link with `[System.IO.File]::Delete` or `[System.IO.Directory]::Delete` (non-recursive). If the path is a plain folder, throw `settings.json.planifest-tmp is a folder: remove it and re-run`.

### S-004: the `PreToolUse` filter removes more than Planifest wrote (Low)

Category: Tampering (loss of user hooks).

The filter (lines 291-297) drops an entry if any of its hooks has a command matching `gate-write`, `ratchet-check`, or `em-dash-guard`.

- `-match` is case-insensitive and unanchored, so `./tools/My-Gate-Write-Audit.sh` matches.
- One match drops the whole entry, including any other user hooks in it.
- ADR-001 removes on any matcher, so a user's `Bash` entry is also at risk. `setup.sh` only touches entries whose matcher is `Write` or `Edit` (setup.sh line 470).

The `UserPromptSubmit` filter (lines 304-310) has the same loose match, but it predates this diff.

Fix: build a regex like the one at line 417, for example `(^|[\s"'/\\])(gate-write|ratchet-check|em-dash-guard)\.mjs\b`, and match with `-cmatch`. Then remove only the matching hooks and drop an entry only when it ends up empty.

### S-005: hook command quoting differs from `setup.sh` (Low)

Category: Tampering (parity).

`New-HookEntry` (line 250) writes `node .claude/hooks/enforcement/gate-write.mjs`. `setup.sh` (lines 447-452) writes `node ".claude/hooks/enforcement/gate-write.mjs"`. The path holds no spaces today, so both commands run. The two scripts still write different strings, and the req-001 parity suite compares module names only. If `EnforcementHooksDir` ever gains a space, every PowerShell-wired hook stops running, and enforcement stops with them.

Fix: write `` "node `"$HooksDir/$Module.mjs`"" `` and extend the parity suite to compare the full command string.

### S-006: `Merge-AllowedTools` edge cases differ from `setup.sh` (Low)

Category: Tampering (integrity of `settings.json`).

- Line 349 uses `-notcontains`, which ignores case. An existing `"agent"` stops `Agent` from being added. `setup.sh` uses a case-sensitive `includes`.
- A string `allowedTools` such as `"Bash"` becomes `["Bash", "Agent"]`. `setup.sh` replaces it with `["Agent"]`. The PowerShell result keeps more user data, but the two scripts disagree.
- If parsing fails (line 341), or the top level is not an object (line 342), the function writes `{"allowedTools":["Agent"]}` over the whole file. `setup.sh` fails in `JSON.parse` and leaves the file alone.
- PowerShell 7 unrolls a one-element top-level array such as `[{"a":1}]`, so `-is [PSCustomObject]` passes and setup rewrites the array as an object. 5.1 does not unroll it, so it overwrites the file instead.

The overwrite is reachable only when `Install-EnforcementHooks` returns early because the hook source is missing (lines 497-500). Otherwise `Merge-EnforcementHookSettings` throws on the bad file first.

Fix: use `-cnotcontains`. On a parse failure or a non-object top level, print a warning and return without writing.

### S-007: one PowerShell 7-only escape remains (Low)

Category: none (compatibility).

`Write-Host "  `u{2705} Git guardrails activated."` (line 557) uses the `` `u{...} `` escape from PowerShell 6. Windows PowerShell 5.1 does not know it and prints `u{2705} Git guardrails activated.` This does not cause a parse error. No other 7-only syntax remains in `setup.ps1` or `setup/claude-code.ps1`. This review checked for these forms:

- `??` and `?.`
- the ternary operator
- `&&` and `||`
- `-AsHashtable` and `-NoEnumerate`
- `ForEach-Object -Parallel`
- `Join-Path` with extra child paths
- `utf8NoBOM` and `-AsByteStream`
- `$IsWindows`

Fix: write `"  $([char]0x2705) Git guardrails activated."`.

Line 752 holds text already stored in its double-encoded form, `Ã¢â‚¬â€`. That predates this diff and shows wrongly on both versions. `setup/claude-code.ps1` has no BOM, so 5.1 reads its em dash as ANSI. The dash sits in a comment on line 14, so it does no harm.

### S-008: tool name case differs from `setup.sh` (Low)

Category: none (parity with ADR-003).

ADR-003 makes flags case-sensitive, but line 1106 still lowercases the tool name. `setup.ps1 Claude-Code` runs, while `setup.sh Claude-Code` fails. Line 37 compares the tool with `-cnotcontains`. As a result, `--backend-url Claude-Code` takes `Claude-Code` as the retired flag's value, and setup then reports that no tool was given.

Fix: drop `ToLower()` and test with `$ValidTools -ccontains $Tool`.

## Checks with no finding

| Area | Result |
|------|--------|
| `remove_leftover_settings_tmp` (`setup.sh:292-297`) | `[ -L ] \|\| [ -f ]` catches dangling links and links to folders. `rm -f` removes the link, not its target. A plain folder stays. If someone swaps in a folder after the test, `rm -f` fails safely without `-r`. |
| Reparse point branch (`setup.ps1:369-372`) | `File.Delete` and non-recursive `Directory.Delete` remove a file symlink, a folder symlink, or a junction without touching the target, on both versions. A hard link is not a reparse point. `Remove-Item` removes only that name. |
| `New-HookEntry` and `ConvertTo-Json -Depth 10` | A function returns an `[ordered]` dictionary as one object, and the pipeline does not unroll it. Both versions write an `IDictionary` and a `PSCustomObject` as the same JSON object, with keys in order. The inner `@(...)` stays a one-element array. Depth 10 covers the six levels the hooks need. Whitespace and the 5.1 `\u0027` escaping differ from `setup.sh`, but the JSON values match. |
| `$filtered + $preToolEntries` (lines 298, 311) | `@(...)` always yields `[object[]]`, including empty and one-element results. `[object[]] + [object[]]` joins them into a flat array. Neither version unrolls it. The same pattern shipped in 0.4.1 for `UserPromptSubmit`. |
| `-is [System.Management.Automation.PSCustomObject]` (line 342) | The full type name is the real `PSCustomObject` class, not the `[pscustomobject]` accelerator. The accelerator maps to `PSObject` and matches almost anything. The check passes for an object from `ConvertFrom-Json`. It fails for `$null`, strings, numbers, and `[object[]]`, on both versions. |
| Empty or missing file in `Merge-AllowedTools` | `Get-Content -Raw` on an empty file returns `$null`. On 5.1, piping `$null` to `ConvertFrom-Json` raises a binding error. `$ErrorActionPreference = 'Stop'` (line 50) makes that error terminating, and the `try` catches it. 7 returns `$null`. Both leave `$settings` as `[PSCustomObject]@{}`, and `Add-Member` works on it. |
| `-isnot [System.Array]` (line 422) | Both versions return a nested JSON array as `[object[]]`, including `[]` and one-element arrays. Only top-level output differs between them, and this check reads a property value. A JSON `null`, string, or object now stays as it was. |
| `switch -CaseSensitive` (line 41) | 5.1 supports `-CaseSensitive`. The retired-flag checks above it already use `-ccontains` and `-ceq`, and `StartsWith(string)` is case-sensitive. A miscased retired flag reaches the `default` branch, prints `Unknown flag`, and exits 1, as `setup.sh` does. |

## Threat Model (STRIDE)

| Threat | Category | Severity | Mitigation |
|---|---|---|---|
| A 5.1 run decodes non-ASCII `settings.json` content wrongly and writes it back (S-001) | Tampering | Medium | Not mitigated |
| A dangling link at the temporary path redirects the 5.1 write outside the project (S-002) | Tampering | Low | Mitigated on 7 and in `setup.sh`. Not mitigated on 5.1 |
| A planted folder leads to a recursive delete prompt (S-003) | Tampering, Denial of Service | Low | Needs local write access and a yes at the prompt |
| The `PreToolUse` filter removes a user hook (S-004) | Tampering | Low | Not mitigated |
| An unquoted hook path silently disables enforcement if the path gains a space (S-005) | Elevation of Privilege | Low | The path holds no spaces today |
| `Merge-AllowedTools` overwrites an unreadable `settings.json` (S-006) | Tampering | Low | Unreachable while the hook source is present |
| The run leaves no log of what it removed from `settings.json` | Repudiation | Low | Setup prints one line for each change. The file is under git in most projects |

## Risk register cross-check

| Risk | Status after review |
|------|---------------------|
| R-001: no runtime test of `setup.ps1` | Open. Every finding here is static. The PR test plan needs a manual run on Windows PowerShell 5.1, with a non-ASCII `settings.json`, to cover S-001. |
| R-002: duplicate `gate-write` after an upgrade | Mitigated. The filter removes the old `Write\|Edit` entry. S-004 records that it now removes too much. |
| R-003: miscased flags fail | Mitigated as designed. S-008 records the tool name gap. |
| R-004: `PSCustomObject` output in `Merge-AllowedTools` | Mitigated. The output shape matches the other writers. |
| R-005: the leftover removal follows a planted link | Mitigated in `setup.sh` and on PowerShell 7. Open on 5.1 for a dangling link (S-002). |

## Dependency Audit

The diff adds no dependencies. Both scripts still call `node` 18+, and the PowerShell script uses only built-in cmdlets and .NET types.

## Secrets Management

The diff handles no secrets. The retired `--backend-url` value is skipped and never printed or stored (lines 28-38). Line 411 records that setup never logs raw `settings.json` content.

## Authentication & Authorisation Review

Not applicable. The scripts run locally as the invoking person and expose no API.

## Input Validation Review

Inputs are command-line arguments and the target project's `settings.json`. S-001, S-004, and S-006 cover the gaps in `settings.json` handling. Flag parsing now matches `setup.sh`, apart from the tool name (S-008).

## Network Policy

Not applicable. Neither script opens a network connection.

## Infrastructure as Code Review

Not applicable. The diff contains no IaC.

## Summary

Overall risk rating: Medium

Top actions before production:

1. Fix S-001. Read `settings.json` as UTF-8 at lines 280 and 412, and write it without a BOM.
2. Fix S-002 and S-003 together. Detect the temporary path without following links, and refuse a plain folder.
3. Tighten the `PreToolUse` filter for S-004, then run the manual Windows PowerShell 5.1 check that R-001 calls for.

## Resolution (after P5 fixes)

The orchestrator fixed all eight findings in `setup.ps1`, and `test-0000035-p5-security-fixes.sh` checks each one.

| ID | Fix |
|----|-----|
| S-001 | Both `Get-Content` reads of `settings.json` name `-Encoding UTF8`. `Write-SettingsAtomic` writes UTF-8 with no BOM through `WriteAllText`. |
| S-002 | A new `Remove-SettingsTmpEntry` reads the entry with `FileInfo`, so it finds a dangling link. |
| S-003 | The helper removes only a file or a link, with `File.Delete` or a non-recursive `Directory.Delete`. A plain folder stays, and the write fails. |
| S-004 | Both hook filters use `-cmatch` on `<module>.mjs` at a path boundary. |
| S-005 | `New-HookEntry` quotes the module path, as `setup.sh` does. |
| S-006 | `Merge-AllowedTools` uses `-cnotcontains`, counts a non-array `allowedTools` as empty, and leaves a non-object file unwritten with a warning. |
| S-007 | The success line uses `$([char]0x2705)`. |
| S-008 | The tool name must match `$ValidTools` exactly, with `-ccontains`. |

Overall risk rating after the fixes: **Low**. R-001 stays open, because no `pwsh` runner exists. The PR test plan includes a manual Windows PowerShell 5.1 run with a `settings.json` that holds non-ASCII text.
