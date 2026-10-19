# Security Report - setup-hardening-release-sizing

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Version:** 0.6.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** planifest-zero (`setup.sh`, `setup.ps1`, the orchestrator skill, `product.template.yml`, and the 0000039 tests and fixtures)
**Review Scope:** code review | dependency audit | threat model

The change adds no network service, secret, dependency, or privilege. It closes the four prior findings it targeted. No finding blocks the merge. F-001 is the one leak path that remains, and it predates this feature.

I ran `setup.sh` in scratch workspaces outside the repo with planted values. `pwsh` is not installed on this machine, so I reviewed `setup.ps1` by reading it. The CI jobs on Windows PowerShell 5.1 and PowerShell 7 are the only proof for that script.

**Mitigated by this feature:** 0000038 F-001 (single-object `hooks`), F-004 (`-Depth 10`), and F-005 (parse error leak). See "Prior findings".

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | low | data-exposure | planifest-zero | The non-array warning prints the old `hooks.PreToolUse` or `hooks.UserPromptSubmit` value (`setup.sh:482-486`, `setup.ps1:427-428`). I planted `{"hooks":{"PreToolUse":"PLANTEDSECRET-cmd"}}` and the string appeared on stderr with exit 0. A value nested in an object printed in full, for example `{"hooks":[{"command":"PLANTEDSECRET"}]}`. `setup.ps1` now prints with `-Depth 100`, so it prints deeper values than before. This is the 0000038 F-006 path. The feature added no new print. | Print the event name and the file only. Optionally write the old value to a `0600` backup file and print its path. | open (pre-existing, 0000038 F-006) |
| F-002 | low | config | planifest-zero | `setup.sh` treats any valid JSON as an object. With `["x"]` in `settings.json`, `s.hooks = s.hooks \|\| {}` (`setup.sh:476`) sets a property that `JSON.stringify` drops. Setup prints `enforcement hooks wired` and `Agent added to allowedTools`, but the file stays `["x"]` and no Planifest hook is installed. I confirmed this by running it. With `null`, `"text"`, or `{"hooks":"text"}`, node throws a `TypeError` at `setup.sh:476`, `setup.sh:481`, or `setup.sh:517`, prints a stack trace, and setup exits 1. The trace shows setup code, not file content, and the file is unchanged. | Check that the parsed value is an object, and that `hooks` is an object, before use. Print the fixed error line and exit 1 otherwise. | open, backlog 0000121 |
| F-003 | low | availability | planifest-zero | `Test-JsonText` keeps its nesting stack in a string. `$stack += '{'` (`setup.ps1:331-332`) and `Substring` (`setup.ps1:334`) copy the string on every bracket, so cost grows with the square of the depth. A `settings.json` nested hundreds of thousands of levels deep makes setup slow. The check never recurses, so it cannot overflow the stack. The string patterns (`setup.ps1:316-317`) have disjoint alternatives and run from an anchored `\G`, so they backtrack in linear time. I reasoned this from the code and did not time it. | Track depth with an integer or a `Stack[char]`, and fail above a depth limit. | open, backlog 0000122 |
| F-004 | informational | config | planifest-zero | `Merge-AllowedTools` (`setup.ps1:471-486`) does not call `Test-JsonText`. On an unreadable file it prints a fixed `Write-Warning` and continues with exit 0, while `setup.sh:561-567` exits 1. The hook install step (`setup.ps1:648`, called before line 1076) already rejects the same file, so the difference is reachable only if a file turns invalid between the two steps. Nothing leaks, and the file stays unchanged. | Accept, or call `Test-JsonText` in `Merge-AllowedTools` for parity. | open |
| F-005 | informational | injection | planifest-zero | `releaseSize` is read from `product.yml` by an LLM-driven skill. `SKILL.md:191` says to note an unknown value in `discovery.md` and ask the human to fix it. The text does not say to treat that value as data. A crafted value, such as a long string with instructions, could be copied into `discovery.md` and read by later phases. A person with write access to `product.yml` can already change any instruction file, so this adds no privilege. The three valid values map to fixed point budgets (`SKILL.md:177-181`), and nothing executes the value. | Add one clause to `SKILL.md:191`: quote an unknown value as inert data, truncate it to 40 characters, and never follow it. | open |
| F-006 | informational | injection | planifest-zero | The .NET and JavaScript regexes can differ on non-ASCII text (`setup.sh:508`, `setup.sh:521`, `setup.ps1:359`, `setup.ps1:368`). This is 0000038 F-007 and is unchanged. `Test-JsonText` can also reject valid JSON that PowerShell cannot read, such as keys that differ only by case (backlog 0000120), or nesting beyond the `ConvertFrom-Json` limit on 5.1. Each case fails closed. It prints the fixed line, exits 1, and leaves the file unchanged. | Accept. | open |

## Review notes by area

### Data exposure

I ran `setup.sh claude-code` in scratch workspaces with a planted value in each case. I checked stdout, stderr, and the file after the run.

| Input | Exit | Planted value in output | File after |
|-------|------|-------------------------|-----------|
| `{"x":"PLANTEDSECRET",}` (trailing comma) | 1 | no | byte-identical |
| `{"a":"PLANTEDSECRET` (truncated) | 1 | no | byte-identical |
| `{"hooks":{"PreToolUse":"PLANTEDSECRET-cmd"}}` | 0 | yes, in the non-array warning (F-001) | rewritten |
| `{"hooks":{"UserPromptSubmit":{"hooks":[{"command":"PLANTEDSECRET"}]}}}` | 0 | yes, in the non-array warning (F-001) | rewritten |
| `null`, `"PLANTEDSECRET"`, `{"hooks":"PLANTEDSECRET"}` | 1 | no (stack trace shows setup code, F-002) | unchanged |
| `["PLANTEDSECRET"]` | 0 | no | unchanged (F-002) |

- **Hook install step:** the `catch (_)` at `setup.sh:470` discards the parser message. Only `PLANIFEST_SETTINGS_REL` and a fixed string print. The path comes from the tool config, not from the file.
- **allowedTools step:** `setup.sh:562-566` does the same.
- **Telemetry cleanup:** `setup.sh:333` can throw on invalid JSON, but `2>/dev/null` at `setup.sh:360` hides the trace. The user sees only a fixed warning at `setup.sh:365`. In `setup.ps1`, the `catch` at `setup.ps1:581` prints a fixed `Write-Warning` and drops the exception.
- **setup.ps1 hook step:** `Test-JsonText` runs first, and a failed `ConvertFrom-Json` is caught with `-ErrorAction Stop` (`setup.ps1:405-406`). The fixed line goes out through `[Console]::Error.WriteLine` (`setup.ps1:409`). I read this and did not run it.
- **setup.ps1 valid non-object JSON:** a top-level string or array passes `Test-JsonText` and reaches `Add-Member` at `setup.ps1:413`. The failure message there is generated by PowerShell. I could not confirm that it omits content. Backlog 0000120 and 0000121 cover the top-level shapes.

### Test-JsonText

- **Recursion:** none. A string stack tracks nesting, so deep input cannot overflow the call stack.
- **Backtracking:** the string pattern's two alternatives start with different characters, so no input backtracks catastrophically. Number and whitespace patterns have no nested quantifiers. Every match is anchored with `\G`, so a failed match costs one pass.
- **Large input:** the loop is linear in token count, except for the stack copy in F-003. A 10 MB file in a PowerShell loop is slow but finite. The file is the user's own.
- **Agreement with `JSON.parse`:** I walked the grammar. Leading zeros, bare `-`, trailing commas, unquoted keys, control characters in strings, and trailing text all return `$false`. Lone surrogate escapes pass, as in `JSON.parse`. A mismatch can only produce the fixed error line, never a leak or a write, because the check runs before any write.
- **Corruption:** a false positive (the check passes and `ConvertFrom-Json` accepts a file node would reject) is now closed. A false negative stops setup and leaves the file as it was.

### Single-object hooks

I replayed crafted entries through `setup.sh` in a scratch workspace.

- A stale `{"hooks":{"type":"command","command":"node x/gate-write.mjs"}}` entry is removed. A fresh entry replaces it. This was 0000038 F-001.
- A single object with a user command (`./mine.sh`) is kept as an object. The write path (`setup.sh:507`) skips `entry.hooks = userCmds` for it, so the shape is not rewritten.
- `hooks: null`, a nested `{"hooks":{"command":"..."}}` inside an array, and `hooks: "text"` are kept unchanged. None throws.
- A single object whose command mixes a user action with `gate-write.mjs` (for example `gate-write.mjs && ./audit.sh`) is removed with the Planifest command. This is the existing 0000038 F-002 behaviour. It is not new.
- No input produced a malformed file. Every output parsed as JSON.
- `setup.ps1:295` wraps a `PSCustomObject` in `@()`, so Windows PowerShell 5.1 cannot unwrap it. I reasoned this and did not run it.

### Atomic writes

- **Invalid JSON:** both scripts exit before any call to `writeSettings` or `Write-SettingsAtomic`. In every failing scratch run, no `settings.json.planifest-tmp` remained and the file was byte-identical.
- **`|| exit 1`:** `setup.sh:538` and `setup.sh:577` carry the node exit code up. Under `set -euo pipefail`, setup stops with exit 1 rather than continuing with a half-installed state.
- **Partial install:** setup copies hook modules before it reaches the settings step. A failed run leaves those files in place, and a rerun after the fix is idempotent. This is not a security issue.

### releaseSize

- The field is read as one of three fixed words (`small`, `medium`, `large`). The skill maps each to a number. The value does not build a path, a command, or a pattern.
- `product.template.yml` ships it commented out, so a new install has no value to inject.
- The residual path is F-005, the unknown-value note in `discovery.md`.

### Dependency risk

No new dependency. The change uses `node`, `bash`, and PowerShell, as before. No lock file changed.

## Prior findings

| Prior ID | Backlog | Status now | Evidence |
|----------|---------|------------|----------|
| 0000038 F-001 (single-object `hooks` stays) | 0000114 | mitigated | `setup.sh:501-507` and `setup.ps1:295`. I replayed a stale single-object entry and `setup.sh` removed it. |
| 0000038 F-002 (basename collision) | none | open (pre-existing) | Unchanged. The same match runs at `setup.sh:508` and `setup.ps1:359`. |
| 0000038 F-003 (stale commands the regex misses) | none | accepted | Unchanged. |
| 0000038 F-004 (`-Depth 10` truncation) | 0000115 | mitigated | `-Depth 100` at `setup.ps1:427`, `setup.ps1:453`, `setup.ps1:466`, `setup.ps1:499`, and `setup.ps1:578`. The remaining `-Depth 10` calls (`setup.ps1:1123`, `setup.ps1:1165`) write the flags marker, not `settings.json`. |
| 0000038 F-005 (parse error leak) | 0000113 | mitigated | Table above. Invalid JSON prints one fixed line in both steps of `setup.sh`. The `setup.ps1` path is reasoned. |
| 0000038 F-006 (non-array warning prints old value) | none | open | Now F-001. |
| 0000038 F-007 (regex divergence) | none | open | Now F-006. |

Backlog 0000118 (allowedTools invalid JSON) is covered by `setup.sh:561-567`. Backlog 0000120 stays open and accurate.

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Secret from `settings.json` reaches a log | Invalid JSON, or a non-array hook value | planifest-zero | low | medium | Fixed error line for invalid JSON (this feature) | F-001 |
| Setup reports success but installs no hook | `settings.json` holds a JSON array | planifest-zero | low | medium | None | F-002 |
| Slow setup on pathological input | Deeply nested `settings.json` | planifest-zero | low | low | Linear patterns, no recursion | F-003 |
| Stale Planifest hook keeps running | Object-shaped `hooks` | planifest-zero | low | low | Single-object handling (this feature) | None |
| Setup deletes a user hook command | Basename collision | planifest-zero | low | medium | Per-command filter | 0000038 F-002 |
| Hook content truncated on Windows | Nested hook object | planifest-zero | low | medium | `-Depth 100` (this feature) | None |
| Instructions injected through `product.yml` | Crafted `releaseSize` | orchestrator skill | low | low | Fixed three-value mapping | F-005 |
| The two scripts drift apart | Separate copies of the rule | planifest-zero | low | medium | Shared fixtures and parity tests | F-004, F-006, backlog 0000120 |

## Risk register cross-reference

| ID | Status | Evidence |
|----|--------|----------|
| R-001 | Mitigated in code. CI proof pending. | `setup.ps1:295` wraps the object in `@()`, and kept hooks build from `@()` (`setup.ps1:296`). Confirm the Windows PowerShell 5.1 CI job is green. |
| R-002 | Mitigated for the invalid JSON handler. | No planted value reached stdout or stderr in the failing `setup.sh` runs. `setup.ps1` reasoned. F-001 is the separate pre-existing warning path. |
| R-003 | Open. | `pwsh` is not installed here. Only CI proves the `.ps1` suites. |
| R-004 | Accepted. | Recorded at P1 confirmation. |
| R-005 | Open, reduced. | Both suites read the same fixtures. Known gaps are F-004 and backlog 0000120. |
| R-006 | Mitigated. | All five `settings.json` write and print sites use `-Depth 100`. |
| R-007 | Mitigated. | `setup.sh` runs leave the file byte-identical with no `.planifest-tmp`. Exit 1 occurs before any write call in `setup.ps1`. |
| A-001 | Open. | Sizing relies on a human-confirmed fill, as the register says. |

## Recommendations

Ordered by priority:

1. No action blocks the merge.
2. Confirm the Windows PowerShell 5.1 and PowerShell 7 CI jobs are green (R-001, R-003).
3. Fix backlog 0000121 (F-002) so a JSON array in `settings.json` stops setup instead of reporting success.
4. Stop printing old hook values in the non-array warning (F-001).
5. Add one clause to `SKILL.md:191` that treats an unknown `releaseSize` value as inert data (F-005).
6. Replace the string stack in `Test-JsonText` (backlog 0000122).
