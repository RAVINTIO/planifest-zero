# Verification Report - 0000039-setup-hardening-release-sizing

## What ran

- **`setup.sh`, local (macOS):** each case used a fresh scratch workspace outside the repo, with a copy of `planifest-zero/` and its own git repo. Each ran `bash planifest-zero/setup.sh claude-code` on a shared fixture from `planifest-zero/tests/fixtures/0000039-setup-hardening/`. The orchestrator then read the exit code, stdout, stderr, and `.claude/settings.json`.
- **`setup.ps1`, CI only:** `pwsh` isn't installed locally. CI run `39187093043` at `cc50ec3` ran `setup.ps1 claude-code` through the 0000039 `.ps1` suite on three hosts: Windows PowerShell 5.1, PowerShell 7 on Windows, and PowerShell 7 on Linux. Each host passed 36 of 36 checks.
- **Skill and template text:** the orchestrator read the changed files and searched `planifest-zero/skills/` and `planifest-zero/templates/` for the old rule.

Nothing was left running.

## Per criterion

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| req-001 (a) fixed message, exit 1, file unchanged | CLI, `setup.sh` on `invalid-settings.json` | verified | Exit 1. Stderr held `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` `cmp` found the file identical to the fixture. No `.planifest-tmp` file remained. |
| req-001 (b) planted value in neither stream | Same run | verified | `PLANTED` and `API_TOKEN` matched 0 lines in stdout and stderr. No stack trace or `SyntaxError` appeared. |
| req-002 (a) Planifest single object gone, fresh entries once | CLI, `setup.sh` on `single-object-hooks.json` | verified | Both single-object Planifest entries are gone. Each of the 9 Planifest commands appears once. |
| req-002 (b) user single object stays | Same run | verified | `node tools/my-lint.mjs` and `node ./tools/notify.sh` stay as single objects, unchanged. A second run gave a byte-identical file. |
| req-003 15-level value survives `setup.ps1` | CI, `.ps1` suite on three hosts | verified | The suite found `leaf-0000039` at the same 15-level path after setup, on each host. |
| req-004 (a) skill defines the setting | File inspection | verified | The skill's Decomposition section holds both tables: budgets of 4, 8, and 14 points with `medium` as default, and classes S, M, and L at 1, 2, and 4 points. Start action 10 reads `releaseSize`. |
| req-004 (b) unknown value handling | File inspection | verified | The skill says to note an unknown value in `discovery.md`, use `medium`, and ask the human to fix the field. |
| req-004 (c) no fixed 3-story rule | Search over `skills/` and `templates/` | verified | No match. Both feature brief templates point to the release-size rule instead. |

## Scope Lock paths

| Path | Outcome | Evidence |
|---|---|---|
| Happy path | verified | See req-002 above. Deep values are covered by req-003 in CI. |
| First run | verified | With no `settings.json`, `setup.sh` exited 0 and wrote 6 `PreToolUse` and 3 `UserPromptSubmit` entries. |
| Error path | verified | See req-001 above. The telemetry cleanup prints its existing warning first: `! Warning: could not remove telemetry hook entries from .claude/settings.json`. It names the file only, as the design expects. |
| Cross-session | verified | A second `setup.sh` run gave a byte-identical file. |

## Not verifiable

None.
