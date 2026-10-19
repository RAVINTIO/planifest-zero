# Security Report - setup-hook-filter-fixes

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Version:** 0.5.1

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** planifest-zero (`setup.sh`, `setup.ps1`, and the 0000038 tests and fixtures)
**Review Scope:** code review | dependency audit | threat model

The change adds no network service, secret, dependency, or privilege. It moves hook filtering from whole entries to single commands in both scripts. No finding needs action before merge. F-005 and F-001 are worth filing.

I ran the `setup.sh` filter logic against crafted entries in node. `pwsh` is not installed on this machine, so I reviewed `setup.ps1` by reading it. The CI jobs on Windows PowerShell 5.1 and PowerShell 7 are the only proof for that script.

**0000037 S-001 is mitigated.** `keepUserCommands` (`planifest-zero/setup.sh:486-497`) and `Remove-PlanifestHookCommands` (`planifest-zero/setup.ps1:278-301`) now remove only the matching commands. An entry with `./my-audit.sh` beside a Planifest command keeps `./my-audit.sh`. The second half of S-001 (a user script with a Planifest basename at another path) is still open. See F-002.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | low | config | planifest-zero | A single-object `hooks` value, such as `{"matcher":"Write","hooks":{"type":"command","command":"node x/gate-write.mjs"}}`, is not an array. `setup.sh:489` and `setup.ps1:287` keep that entry unchanged. A stale Planifest command in that shape stays, and setup appends a fresh entry beside it, so the hook runs twice. Both scripts behave the same, and a node replay confirmed `setup.sh` keeps it. Behaviour changed: before this feature `setup.sh` threw a TypeError on `.some` for this shape, and `setup.ps1` removed the entry. | Treat an object `hooks` value as a one-item array, or print a warning when setup keeps a non-array `hooks` value that names a Planifest module. | open |
| F-002 | low | config | planifest-zero | The match removes any command with `<module>.mjs` at a path boundary. A user script such as `/home/u/tools/gate-write.mjs`, or `echo gate-write.mjs`, is removed. The match is at `setup.sh:501`, `setup.sh:514`, `setup.ps1:359`, and `setup.ps1:368`. Node confirmed both removals. This is pre-existing for `PreToolUse` in both scripts. For `UserPromptSubmit`, the new `setup.sh` match is narrower than the old substring test, so it is an improvement there. | Narrow the match to the hooks folder after the legacy folder shapes are inventoried. `design.md` already defers this. | open (pre-existing, partly reduced) |
| F-003 | low | config | planifest-zero | A stale Planifest command that the regex misses stays. Examples are `GATE-WRITE.MJS` (the match is case-sensitive) and a command without `.mjs`. `setup.sh` used a bare substring for `UserPromptSubmit`, so extensionless old commands used to go. They now stay and run beside the fresh entry. This follows ADR-002 and assumption A-001. | Accept. Add a line to the release notes saying a user removes a stale command by hand. | accepted |
| F-004 | low | data-exposure | planifest-zero | `ConvertTo-Json -Depth 10` at `setup.ps1:371`, `setup.ps1:384`, `setup.ps1:417`, and `setup.ps1:496` truncates any value deeper than 10 levels when setup rewrites `settings.json`. A hook entry sits at depth 5, so a user hook object with a nested `env` or similar block of six or more levels is cut. Windows PowerShell 5.1 cuts it without a warning, and setup writes the shortened file. The depth is pre-existing and this feature did not change it. The new function keeps more user commands, so it adds no new loss. The same limit applies to the recovery print at `setup.ps1:346`. `setup.sh` has no limit. | Raise `-Depth` to 100 on every settings write, or fail when the input is deeper than the limit. | open (pre-existing, 0000037 S-003) |
| F-005 | low | data-exposure | planifest-zero | Invalid JSON in `.claude/settings.json` makes `JSON.parse` throw at `setup.sh:465` (and `setup.sh:333`, `setup.sh:542`). Node prints the offending source line and a stack trace to stderr, and `setup.sh` exits 1. A planted `"x": "secretvalue"` appeared in that output, so a token in a malformed `settings.json` reaches a CI or shared log. The file stays unchanged. This is pre-existing: it also happens on `main`. `setup.ps1:330` is a milder case. `ConvertFrom-Json` throws under `$ErrorActionPreference = 'Stop'` (line 59) and setup stops. The error text names the path, line, and position, and can include the bad token. I read it and did not run it. | Wrap `JSON.parse` in try/catch. Print a fixed message with the file path only, and exit non-zero. Do the same around `setup.ps1:330` and `setup.ps1:465`. | open (pre-existing, backlog 0000113) |
| F-006 | low | config | planifest-zero | The non-array warning still prints the old `hooks.PreToolUse` or `hooks.UserPromptSubmit` value (`setup.sh:470-478`, `setup.ps1:346`). A hand-written command can hold a token. This feature added no new print. | Accept, as 0000037 S-002 did. Optionally write the old value to a `0600` backup file and print its path. | open (pre-existing, 0000037 S-002) |
| F-007 | informational | injection | planifest-zero | The .NET regex in `setup.ps1` and the JavaScript regex in `setup.sh` can differ on non-ASCII text. .NET `\b` treats `é` as a word character, so `gate-write.mjsé` does not match in `setup.ps1` but does in `setup.sh`. A real hook command is unlikely to hit this. | Add the case to the parity fixture, or accept. | open |

## Review notes by area

### Injection

- Both regexes are literals (`setup.sh:501`, `setup.sh:514`, `setup.ps1:359`, `setup.ps1:368`). Settings data never builds a pattern, so a crafted command can't alter the match.
- The patterns have no nested quantifiers, so a long command can't cause catastrophic backtracking.
- `PLANIFEST_WRITE_SETTINGS_JS` is a fixed string. Paths and commands reach node through env vars and the parsed file only. The feature adds no `node -e` interpolation.
- `String((h && h.command) || "")` at `setup.sh:493` and `"$($hook.command)"` at `setup.ps1:289` convert a non-string command, so a number or object can't throw there.

### Crash, deletion, and stale-command checks

- A crafted `settings.json` can't crash the new filter. Node replays with `null` entries, string entries, number entries, `null` hooks and `{command:5}` hooks all returned without a throw. `setup.ps1` guards `$null` entries at line 284.
- The filter drops only an entry that had commands and has none left. An entry with `hooks: []` or a missing `hooks` value stays.
- Crashes that remain are pre-existing and sit outside the filter. `settings.json` containing `null` makes `s.hooks` throw at `setup.sh:466`. A string `hooks` value makes `s.hooks.PreToolUse.push` throw. Both stop setup before it writes, so no data is lost.
- Deletion of user commands is limited to F-002.
- Stale Planifest commands can survive in the cases F-001 and F-003 describe.

### Credential handling

- The new code prints nothing from `settings.json`. `Remove-PlanifestHookCommands` and `keepUserCommands` have no logging.
- The 0000038 tests use `mktemp -d` (`test-0000038-req-001-002-sh-hook-filter.sh:21`) and remove the directory at the end. The fixture `settings-before.json` holds no token or key.
- Existing leaks are F-005 and F-006.

### Path traversal

- The change builds no path from settings data. `$SettingsPath`, `$settings`, and `$sf` are unchanged. `setup.ps1` still writes through `Write-SettingsAtomic` (line 240).

### Dependency risk

No new dependency. The change uses `node`, `bash`, and PowerShell, as before. No lock file changed.

### Data exposure

Setup must not log `settings.json` contents. This change complies. F-005 and F-006 are the two existing paths that break the rule, and neither is new.

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Setup deletes a user hook command | A user command shares an entry with a Planifest command | planifest-zero | low | medium | Per-command filter (ADR-002) | Basename collision, F-002 |
| A stale Planifest hook keeps running | Object-shaped `hooks`, upper-case name, or no `.mjs` | planifest-zero | low | low | Regex at a path boundary | F-001, F-003 |
| Hook content truncated on Windows | Nested user hook object deeper than 10 levels | planifest-zero | low | medium | None | F-004 |
| Secret from `settings.json` reaches a log | Invalid JSON, or a non-array hook value | planifest-zero | low | medium | Fixed warning text for non-array values only | F-005, F-006 |
| Code injection through `settings.json` | Crafted command string | planifest-zero | low | high | Fixed script, literal regexes, env vars | None |
| The two scripts drift apart | Separate copies of the rule | planifest-zero | low | medium | Shared fixture and parity tests | F-007 |

## Risk register cross-reference

| ID | Status | Evidence |
|----|--------|----------|
| R-001 | Mitigated in code. CI proof pending. | `setup.ps1:296` assigns `$keptHooks` from an `@()` array and the function emits entries, not pipelines. Callers wrap the output in `@()` (lines 358 and 367). The 5.1 CI step is at `.github/workflows/planifest.yml:60-64`. I could not run it here, so confirm that job is green. |
| R-002 | Mitigated. | Both suites include a run-twice case. The filter removes every Planifest command before it appends. F-001 is the one shape where a rerun can add a second copy. |
| R-003 | Open. | `pwsh` is not installed here. Only CI proves the `.ps1` suite. |
| R-004 | Mitigated, with one gap. | Both suites use `tests/fixtures/0000038-hook-filter` and `expected-after.txt`. F-007 is a regex divergence the fixture does not cover. |
| A-001 | Open. | F-003 confirms the assumption holds. A stale user command stays and the user removes it by hand. |

## Recommendations

Ordered by priority:

1. No action blocks the merge.
2. File F-005 as backlog 0000113: catch the `JSON.parse` error in `setup.sh` and print a fixed message with no file content.
3. File F-001: treat an object-shaped `hooks` value as a one-item array in both scripts.
4. Raise `-Depth` to 100 in `setup.ps1` (F-004).
5. Confirm the Windows PowerShell 5.1 CI job is green before merge (R-001, R-003).
6. Add the release-note line for F-003.
