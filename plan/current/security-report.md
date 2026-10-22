# Security Report - setup-cleanup-and-park-hardening

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Version:** 0.8.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** planifest-zero (`setup.sh`, `setup.ps1`, `skills/planifest-orchestrator/scripts/park.mjs`, and the 0000041 tests)
**Review Scope:** code review | dependency audit | threat model

The feature closes the old-value leak in the non-array warning. Neither setup script now prints a hook value or any settings content on any path I tested. That covers the warnings, the fixed error lines, and the node stack traces.

The new `removeEntry` cleanup in `park.mjs` has two edge cases. Each deletes a file the agent or the repo pointed it at. I confirmed both in a scratch repo. Neither needs more than a mistaken `--entry` path or a symlink committed to `main`. No finding is Critical, High, or Medium.

I ran three bash suites, and all passed:

| Suite | Result |
|-------|--------|
| `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | 42 of 42 |
| `test-0000041-req-004-park-commit-failure.sh` | 19 of 19 |
| `test-0000037-req-008-non-array-hook-events.sh` | 68 of 68 |

`pwsh` is not installed here, so I reviewed `setup.ps1` by reading it.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | low | data-exposure | planifest-zero | If `--entry` names the target path itself, a failed commit deletes the only copy of the entry. `park.mjs:173` writes the entry over itself. `park.mjs:180` then calls `removeEntry`, and `rmSync` at `park.mjs:156` deletes it. I passed `--entry plan/backlog/0000900-park-demo/entry.md` with a refusing `pre-commit` hook. The script exited 1 and the folder was empty. Before 0000041 the file stayed. The skill tells the agent to write the entry outside the working tree (`SKILL.md:126`), so this needs an agent slip. | In `parkContext` (`park.mjs:123`), refuse an `--entry` whose resolved path equals `resolve(entryPath)`. | not mitigated |
| F-002 | low | path traversal | planifest-zero | The containment check at `park.mjs:119-121` uses `resolve`, which never follows a symlink. Say `origin/main` holds a symlink at `plan/backlog` or at the entry folder. Then `writeFileSync` (`park.mjs:173`, pre-existing) overwrites `entry.md` in the target. `git add` fails with `beyond a symbolic link`, and the new `rmSync` (`park.mjs:156`) deletes that file outside the repo. I confirmed both steps with a planted `outside/0000900-park-demo/entry.md`. The name is always `entry.md`, and the attacker needs write access to `main`. | Check the `realpathSync` of the entry folder against the real `plan/backlog/` before the write and before `rmSync`. | not mitigated, backlog 0000142 |
| F-003 | low | data-exposure | planifest-zero | Pre-existing, backlog 0000139. A read-only `settings.json` makes `accessSync` at `setup.sh:37` throw from `setup.sh:561`. An unreadable one makes `readFileSync` at `setup.sh:485` throw. Neither throw has a handler, so node prints a stack trace with the absolute path, which names the user's home folder. I planted three secrets in the env, a hook command, and a non-array hook value. In both cases, 0 of 3 appeared in stdout or stderr. Node prints the source line of the eval script, never file data. `setup.ps1:246` throws the path in its message under `$ErrorActionPreference = 'Stop'` (`setup.ps1:59`). I reasoned this and did not run it. | Catch the error and print one fixed line with the relative path, as 0000139 suggests. | open, backlog 0000139 |
| F-004 | informational | config | planifest-zero | On a read-only file, the non-array warning prints before the write fails. It says "Setup replaced it with the Planifest entries", but the file stays unchanged (`setup.sh:510-511` before `setup.sh:561`, `setup.ps1:479` before `setup.ps1:504`). I saw this line, then the stack trace from F-003. | Fold into 0000139: print the warning after the write succeeds. | open |
| F-005 | informational | data-exposure | planifest-zero | ADR-003 drops the old value with no backup. A non-array `hooks.PreToolUse` or `hooks.UserPromptSubmit` value is gone after a run, and the human can't recover it from the output. That loss is the cost of not printing secrets. | Accept, as ADR-003 decided. | accepted |
| F-006 | informational | config | planifest-zero | The installed copy `.claude/skills/planifest-orchestrator/scripts/park.mjs` lacks the cleanup. `diff` against the source shows the missing `removeEntry` and `try` block. An agent running the installed copy still leaves the entry behind after a failed commit. | Rerun setup in P4 to refresh the installed copy, as R-003 plans. | open |

## Review notes by area

### Injection

- **Inline node in `setup.sh`:** `PLANIFEST_SETTINGS_SHAPE_JS` (`setup.sh:62-65`) is a fixed string. Both scripts append it to the fixed `PLANIFEST_WRITE_SETTINGS_JS` at `setup.sh:336` and `setup.sh:471`. The paths and hook commands reach node through environment variables, so no value enters the script text. The single quotes around each script stop the shell from expanding anything inside.
- **PowerShell:** `Read-SettingsObject` (`setup.ps1:387-418`) parses text and returns a status word. It builds no command or script. `Remove-LegacyTelemetryWiring` builds `$moduleRegex` from the constant `$TelemetryHookModules`, not from file content.
- **git in `park.mjs`:** `removeEntry` passes `['reset', '-q', '--', ctx.entryPath]` as an argv array (`park.mjs:154`). No shell parses it, and `--` ends option parsing. `entryPath` always starts with `plan/backlog/`, so git can't read it as pathspec magic. `BACKLOG_ID` and `SLUG` (`park.mjs:59-60`) allow no glob characters.

### Credential handling

- **Non-array warning:** both scripts now print the event and the file only (`setup.sh:510-511`, `setup.ps1:479`). `git grep "Old value"` finds the phrase only in test assertions. The req-003 suites assert that a planted secret never appears.
- **Cleanup skip:** `remove_legacy_telemetry_wiring` catches the parse failure (`setup.sh:348`) and prints `none` (`setup.sh:349`). The block also sends stderr to `/dev/null` (`setup.sh:376`), so a stack trace there never reaches the terminal. `setup.ps1:604` skips without output, and `setup.ps1:639` prints a fixed warning with no exception text.
- **Parser messages:** recent V8 `JSON.parse` messages quote part of the input. Every `JSON.parse` of settings sits in a `try` whose `catch` drops the error (`setup.sh:348`, `setup.sh:486`, `setup.sh:587`). `ConvertFrom-Json` at `setup.ps1:407` sits in a `try` whose `catch` drops it too.
- **Stack traces:** F-003 covers the only uncaught paths I found. They print the absolute path and no content.

### Path traversal

- `removeEntry` deletes only `ctx.entryPath`. That path is `plan/backlog/{7 digits}-park-{slug}/entry.md`, and `SLUG` forbids `/` and `.`. With no symlinks, it can't name anything outside its entry folder.
- `rmSync` runs with `force: true` and no `recursive`. If the path is a directory, `rmSync` throws, and the `catch` at `park.mjs:157` drops the error. If `entry.md` is itself a symlink, `rmSync` removes the link, not its target.
- Two cases escape the intended file: F-001 (the source and target are the same file) and F-002 (a symlinked parent folder).

### Dependency risk

No new dependency. `park.mjs` adds only `rmSync` from `node:fs` (`park.mjs:52`). No lock file changed.

### Data exposure

Beyond F-003, setup prints only relative paths and fixed lines. `park.mjs` rethrows the original git error after cleanup (`park.mjs:181`). The req-004 suite asserts that a failed cleanup prints no stack trace.

## Prior findings

| Prior ID | Backlog | Status now | Evidence |
|----------|---------|------------|----------|
| 0000040 F-009 (old value printed) | 0000130 | mitigated | `setup.sh:510-511`, `setup.ps1:479`, req-003 suites |
| 0000040 F-006 (`--entry` reads any file) | none | open | Unchanged (`park.mjs:123-124`) |
| 0000040 F-007 (git stderr printed verbatim) | none | accepted | Unchanged (`park.mjs:69-70`) |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Secret from `settings.json` reaches a log | Non-array hook value, parse failure, or stack trace | setup.sh, setup.ps1 | low | high | Fixed lines, dropped parser errors, planted-secret tests | None found |
| Parked entry lost | `--entry` equals the target path, then the commit fails | park.mjs | low | low | Skill says to write the entry outside the tree | F-001 |
| File outside the repo overwritten or deleted | Symlink at `plan/backlog` committed to `main` | park.mjs | low | medium | Fixed `entry.md` name, needs write access to `main` | F-002 |
| Home folder path in output | Read-only or unreadable `settings.json` | setup.sh, setup.ps1 | medium | low | None | F-003 |
| Shell injection | Metacharacters in paths or hook commands | setup.sh, park.mjs | low | high | Environment variables and argv arrays | None |

## Risk register cross-reference

| ID | Status | Evidence |
|----|--------|----------|
| R-001 | open | `pwsh` is not installed here. Only CI proves the PowerShell suite. |
| R-002 | mitigated | req-003 (c) passed: the warning text is identical in both scripts. |
| R-003 | open | The installed `park.mjs` still differs from the source (F-006). |
| R-004 | mitigated | The warning drops the value. No planted secret reached output in the suites or in my read-only run. |
| A-001 | mitigated | The req-004 suite forces the failure with a `pre-commit` hook and passed 19 of 19. |
| A-002 | open | The PowerShell suite must show RED then GREEN in CI. |

## Recommendations

Ordered by priority:

1. Rerun setup to refresh the installed `park.mjs`, then confirm `diff` shows no change (F-006, R-003).
2. Confirm the PowerShell 7 and Windows PowerShell 5.1 CI jobs are green (R-001, A-002).
3. Refuse an `--entry` that resolves to the target path (F-001).
4. Add a `realpathSync` containment check before the entry write and delete (F-002, backlog 0000142).
5. Catch write and read errors in the hook install step, and print the warning only after a successful write (F-003, F-004, backlog 0000139).
