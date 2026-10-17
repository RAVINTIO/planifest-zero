# Verification Report - 0000038-setup-hook-filter-fixes

## What ran

- **`setup.sh`, local (macOS, Node v26.3.0):** each case used a fresh scratch workspace with a copy of `planifest-zero/` and its own git repo. Each ran `bash planifest-zero/setup.sh claude-code`, then the resulting `.claude/settings.json` was inspected.
- **`setup.ps1`, CI only:** `pwsh` isn't installed locally. CI run `39074719087` at `68eb9d0` ran `setup.ps1 claude-code` through the 0000038 `.ps1` suite on Windows PowerShell 5.1, PowerShell 7 on Windows, and PowerShell 7 on Linux. Each host passed 32 of 32 checks.

Nothing was left running. The scratch workspaces were outside the repo.

## Per criterion

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| req-001 (a) user command in a shared entry stays | CLI, `setup.sh` on `settings-before.json` | verified | `PreToolUse \| Write \| node tools/my-lint.mjs` and `UserPromptSubmit \| .* \| node ./tools/notify.sh` remain. Their Planifest siblings are gone. |
| req-001 (b) Planifest-only entry gone, fresh entries once | Same run | verified | The `Write\|Edit` ratchet and em-dash entry is gone. Each of the 9 Planifest commands appears once. |
| req-001 (c) second run byte-identical | Second `setup.sh` run, then `cmp` | verified | `cmp` reported no difference. Both runs exited 0. |
| req-002 (a) substring and case variants survive | Same run | verified | `my-check-design-helper.sh` and `Check-Design.mjs` remain, and so does `tools/Gate-Write.mjs`. |
| req-002 (b) earlier command shapes removed | Same run | verified | Quoted and unquoted `.claude/hooks/enforcement/<module>.mjs` commands are gone, with no duplicate. |
| req-002 (c) `setup.ps1` matches `setup.sh` | CI, `.ps1` suite on three hosts | verified | 32 of 32 on each host, including the exact compare to `expected-after.txt`. |

## Scope Lock paths

| Path | Outcome | Evidence |
|---|---|---|
| First run | verified | With no `settings.json`, `setup.sh` exited 0 and wrote 6 `PreToolUse` and 3 `UserPromptSubmit` entries. |
| Error path | verified, with a pre-existing gap | With invalid JSON, the file stayed byte-identical. `setup.sh` exited 1 and printed the bad line with a stack trace. `main` does the same. Filed as backlog 0000113. |
| Single-object `hooks` | verified | The new `setup.sh` kept the entry and exited 0. The `setup.sh` on `main` exited 1 on the same input. |
