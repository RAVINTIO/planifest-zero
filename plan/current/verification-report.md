# Verification Report - 0000041-setup-cleanup-and-park-hardening

## What ran

- **`setup.sh`, local (macOS):** each case used a fresh workspace under the session scratchpad. The workspace held a copy of `planifest-zero/`, its own `git init` repo, and an empty `.claude/`. Each input went to `.claude/settings.json` with `printf '%s\n'`. Each run was `GIT_CEILING_DIRECTORIES=<parent> bash planifest-zero/setup.sh claude-code` from inside the workspace. The run then read the exit code, stdout, stderr, and a `cmp` of the file against a copy taken before setup.
- **`park.mjs`, local (macOS):** the steps of `planifest-zero/tests/test-0000041-req-004-park-commit-failure.sh`, run by hand. Each case used a scratch bare origin, a seed clone, and a working clone. `main` held one commit. The feature branch `feat/0000777-demo` held a committed `plan/current/park.md`. A stub `gh` came first on `PATH` and logged each call. Git used a scratch global config. A `pre-commit` hook refused commits only on `chore/park-0000777-demo`. The run called `node planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` with `park` and `finish-pr`. It read the exit code, both streams, the branch, `git status --porcelain --untracked-files=all`, `git diff --cached`, the refs on origin, and the `gh` log.
- **`setup.ps1`, not run locally:** `pwsh` is not installed. The execution evidence is CI run 39864514066 on PR #18, job `windows-powershell` (120123229468). On Windows PowerShell 5.1.26100 and PowerShell 7.6.6, `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` passed 78 of 78. The job log holds 0 `FAIL:` lines.
- **Installed copy refresh:** `bash planifest-zero/setup.sh claude-code` in the repo root, then a `diff` of the two `park.mjs` copies.

All scratch workspaces stay under the session scratchpad. Nothing was left running.

## Feature brief criteria

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| `setup.sh` given `null`, `["x"]`, or `{"hooks":"text"}` prints only the shape line, exits 1, file unchanged | CLI, `setup.sh` on each input | verified | Each run exited 1. Stderr held 1 line: `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` Stdout held 0 `telemetry` lines. `cmp` found each file identical. |
| `setup.ps1` given a one-item array with a telemetry entry exits 1 with the shape line, file byte-identical | CI, `windows-powershell` job | not-verifiable | `pwsh` is not installed. In CI, `req-002 (a)` passed on 5.1 and 7. Locally, `setup.sh` on the same input exited 1 with only the shape line and an identical file. |
| `setup.ps1` given `null` or `{"hooks":"text"}` prints only the shape line and exits 1 | CI, `windows-powershell` job | not-verifiable | `pwsh` is not installed. In CI, `req-002 (b)` passed on 5.1 and 7. |
| Both scripts given `{bad` print only the invalid JSON line, exit 1, file unchanged | CLI for `setup.sh`, CI for `setup.ps1` | not-verifiable | The `setup.sh` half is verified. It exited 1, and stderr held 1 line: `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` `cmp` found the file identical. The `setup.ps1` half rests on CI `req-002 (b): {bad`. |
| Both scripts warn on a non-array `hooks.PreToolUse` holding a secret, without the secret | CLI for `setup.sh`, CI for `setup.ps1` | not-verifiable | The `setup.sh` half is verified. Input `{"hooks":{"PreToolUse":"PLANTED-SECRET"}}` exited 0. Stderr held 1 line: `  ! Warning: hooks.PreToolUse in .claude/settings.json is not an array. Setup replaced it with the Planifest entries.` `PLANTED` matched 0 lines in both streams. The `setup.ps1` half rests on CI `req-003 (a)`. |
| A failed chore commit makes `park.mjs` exit non-zero, return to the feature branch, and leave no entry file or staged change | CLI, `park.mjs park` with the refusing hook | verified | Exit 1. Stderr: `park: git commit -m chore(backlog): park 0000777-demo failed (exit 1):` then `stub: pre-commit refused`. The branch was `feat/0000777-demo` at its old head `c8c2e6c`. `git status --porcelain --untracked-files=all` and `git diff --cached --name-only` were both empty. |

## Requirement criteria

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| req-001 (a) `null`, `["x"]`, `{"hooks":"text"}` print only the shape line | CLI, `setup.sh` on each input | verified | Exit 1 on each. Stderr held exactly 1 line, the shape line. Stdout held no cleanup line. Stderr held no `could not remove telemetry hook entries` warning. `cmp` found each file identical. |
| req-001 (b) `{bad` prints only the invalid JSON line | CLI, `setup.sh` | verified | Exit 1. Stderr held exactly 1 line: `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` `cmp` found the file identical. |
| req-001 (c) valid object loses its telemetry entry, and a write error still warns | CLI, `setup.sh` on a `Stop` entry for `emit-event.mjs`, then the same file at mode `444` | verified | The writable run exited 0 with an empty stderr. Stdout held `  - removed telemetry hook entries from .claude/settings.json`. The file held 0 `emit-event` matches. The read-only run printed `  ! Warning: could not remove telemetry hook entries from .claude/settings.json`. Stdout then held `  + .claude/hooks/enforcement/gate-write.mjs`, so setup went on to the install step. |
| req-002 (a) one-item array with a telemetry entry | CI, `windows-powershell` job | not-verifiable | `pwsh` is not installed. CI asserts exit 1, the shape line, exactly one error line, and identical Base64 bytes. It passed on 5.1 and 7. |
| req-002 (b) `null`, `{"hooks":"text"}`, `{"a":1,"A":2}`, and `{bad` | CI, `windows-powershell` job | not-verifiable | `pwsh` is not installed. CI asserts the shape line for the first three inputs and the invalid JSON line for `{bad`, with identical bytes. It passed on 5.1 and 7. |
| req-002 (c) valid object loses its telemetry entry | CI, `windows-powershell` job | not-verifiable | `pwsh` is not installed. CI asserts exit 0, the removal line, no `emit-event.mjs`, and the user entry kept. It passed on 5.1 and 7. |
| req-003 (a) exact warning, secret in neither stream | CLI for `setup.sh`, CI for `setup.ps1` | not-verifiable | The `setup.sh` half is verified for both events. Each run exited 0 with 1 stderr line, the exact warning for `PreToolUse` or `UserPromptSubmit`. `PLANTED` matched 0 lines in both streams. The `setup.ps1` half rests on CI. |
| req-003 (b) the event holds only Planifest entries, and absent or `null` gives no warning | CLI for `setup.sh`, CI for `setup.ps1` | not-verifiable | The `setup.sh` half is verified. After the run, every `PreToolUse` command named a `.claude/hooks/enforcement/*.mjs` module. Every `UserPromptSubmit` command did too. `{"hooks":{}}` and `{"hooks":{"PreToolUse":null,"UserPromptSubmit":null}}` each exited 0 with an empty stderr. The `setup.ps1` half rests on CI. |
| req-003 (c) the suite asserts identical text, and no test asserts `Old value:` as present | Test inspection, `grep -rn "Old value" planifest-zero/tests` | verified | All 8 matches assert absence. `test-0000041-req-001-003-sh-cleanup-and-warning.sh` extracts the line from both scripts and asserts them equal. `grep -c 'Old value'` found 0 in `setup.sh` and `setup.ps1`. |
| req-004 (a) failing `pre-commit` gives non-zero exit and the git error, and a failed cleanup never replaces it | CLI, `park.mjs park`, then again with a hook that runs `chmod a-w plan/backlog/0000900-park-demo` before refusing | verified | Both runs exited 1. Both printed `park: git commit -m chore(backlog): park 0000777-demo failed (exit 1):` and `stub: pre-commit refused`. In the second run the delete failed and `entry.md` stayed, untracked. No stack trace appeared. `finish-pr` gave the same exit and error. |
| req-004 (b) on the feature branch, no entry file, no staged change, `park.md` still committed | CLI, after the failed `park` | verified | The branch was `feat/0000777-demo` with its head unchanged. Status and the cached diff were both empty. `git show feat/0000777-demo:plan/current/park.md` printed the park record. The `gh` log held only `pr list`. After the hook was removed, a second `park` exited 0 and filed the entry on the chore branch. |
| req-004 (c) push and `gh` failures unchanged, existing park tests pass | CLI, `park.mjs park` with a missing origin and with a refusing `gh pr create`, plus `git diff main` | verified | The push failure exited 1 with `fatal: '.../park/missing.git' does not appear to be a git repository`. The branch stayed on the feature branch and the `gh` log was empty. The `gh` failure exited 1 with `stub: gh pr create refused` and returned to the feature branch. `git diff main` on `park.mjs` touches only the add and commit block. `test-0000040-req-004-005-park.sh` passed 104 of 104. |

## Semantic coverage

| Criterion | Test file | Test name |
|---|---|---|
| req-001 (a) | `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | `req-001 (a): stderr holds only the shape line on $input`, and the exit, cleanup warning, and byte-identical checks |
| req-001 (b) | `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | `req-001 (b): stderr holds only the invalid JSON line on {bad` |
| req-001 (c) | `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | `req-001 (c): stdout holds the removal line once` and `req-001 (c): a failed cleanup write prints the cleanup warning once` |
| req-002 (a) | `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | `req-002 (a): [{"hooks":{"Stop":[...]}}]` through `Assert-OnlyLine` |
| req-002 (b) | `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | `req-002 (b): $json` and `req-002 (b): {bad` through `Assert-OnlyLine` |
| req-002 (c) | `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | `req-002 (c): the telemetry entry is gone` |
| req-003 (a) | `test-0000041-req-001-003-sh-cleanup-and-warning.sh`, `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | `req-003 (a): stderr holds exactly the new warning for $EV` and `req-003 (a): the $ev warning is exactly the new line` |
| req-003 (b) | both of the above | `req-003 (b): $EV holds only the Planifest entries after the run` and `req-003 (b): no warning when both events are $case` |
| req-003 (c) | `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | `req-003 (c): the warning text is identical in setup.sh and setup.ps1` |
| req-004 (a) | `test-0000041-req-004-park-commit-failure.sh` | `req-004: park prints the exact git error` and `req-004: the original git error survives a failed cleanup` |
| req-004 (b) | `test-0000041-req-004-park-commit-failure.sh` | `req-004: no staged or untracked change remains` and `req-004: park.md is still committed on the feature branch` |
| req-004 (c) | `test-0000040-req-004-005-park.sh` | `req-004: park exits non-zero when the push fails` and `req-004: park exits non-zero when gh pr create fails` |

Every requirement criterion has a covering test. Local runs passed `test-0000041-req-001-003-sh-cleanup-and-warning.sh` (42 of 42) and `test-0000041-req-004-park-commit-failure.sh` (19 of 19). Both copies of `test-0000037-req-008-non-array-hook-events.sh` passed 68 of 68.

## Installed copy refresh

- `bash planifest-zero/setup.sh claude-code` in the repo root exited 0 with an empty stderr.
- `diff planifest-zero/skills/planifest-orchestrator/scripts/park.mjs .claude/skills/planifest-orchestrator/scripts/park.mjs` exited 0 with no output. The two copies match.
- `git status --short` then showed one changed tracked file, `plan/state/claude-code.md`. Only its `writtenAt` value moved, from `2026-10-19T21:53:24Z` to `2026-10-22T22:33:42Z`. Nothing was reverted.
- `plan/backlog/0000142-park-entry-path-follows-symlinks/` was untracked before the setup run. The setup run did not create it.

## RED evidence in CI for req-002 and req-003

A throwaway draft PR #19 ran the new suites against the old `setup.ps1` (run 39865495758). Its branch held the 0000041 tests with the `main` copy of `setup.ps1`.

| Host | `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | req-002 (a) one-item array |
|------|------|------|
| Windows PowerShell 5.1.26100 | 55 passed, 23 failed | fails: exit 0, removal line printed, file rewritten |
| PowerShell 7.6.7 | 57 passed, 21 failed | fails: exit 0, removal line printed, file rewritten |

This confirms that the 0000128 array rewrite is real on both hosts. The PR is closed and its branch deleted. Against the new `setup.ps1`, the same suite passes 78 of 78 on both hosts (run 39864514066).

## P4 fix: park refuses an --entry that is the target path

Security finding F-001 showed that a failed commit deleted the only copy when `--entry` named the target path. `parkContext` now refuses that path before any git call.

- Command: `node park.mjs park --entry plan/backlog/0000900-park-demo/entry.md --backlog-id 0000900`, with the entry copied to that path.
- Before the fix: exit 1 with the pre-commit error, and the entry file was gone.
- After the fix: exit 1 with `--entry must not be the target path`, and the entry file survives.
- `test-0000041-req-004-park-commit-failure.sh`: RED at 21 passed and 2 failed, GREEN at 23 passed. `test-0000040-req-004-005-park.sh` still passes 104 of 104.
- Setup refreshed the installed copy, and `diff` shows the two `park.mjs` copies match.

## Observations

- With a read-only `settings.json`, the cleanup warns as required. The install step then fails in `writeSettings` with an uncaught `EACCES` stack trace and exit 1. Backlog 0000139 already tracks this, so no new entry was filed.
- After a failed chore commit, park leaves an empty `plan/backlog/0000900-park-demo/` folder in the working tree. Git does not track empty folders, so status stays clean. The local `chore/park-0000777-demo` branch also stays at `main`. A second `park` reused it and succeeded.
- A successful `park` deletes the source file passed to `--entry`.

## Not verifiable

- Brief criteria 2 to 5, req-002 (a) to (c), and req-003 (a) and (b) need `setup.ps1`. `pwsh` is not installed locally. CI run 39864514066, job `windows-powershell`, is the execution evidence. Where a criterion also covers `setup.sh`, that half is verified above.

## Totals

- Verified: 9 criteria (brief 1 and 6, req-001 a to c, req-003 c, req-004 a to c).
- Failed: 0.
- Not-verifiable: 9 criteria (brief 2 to 5, req-002 a to c, req-003 a and b).
