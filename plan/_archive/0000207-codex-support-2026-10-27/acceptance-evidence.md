# Acceptance evidence - 0000207-codex-support

1. **Checks:** every suite under `ravintio-zero/tests/` ran from the repo root. 197 feature suites and 19 regression checks passed. The PowerShell runner passed 19 suites under `pwsh` 7.6. The one failure is `test-0000151-req-014`, which compares installed skill copies under `.claude/skills/` with the source. That folder is git-ignored and absent in CI. Step 13 refreshes it. No self-correct cycle ran.
2. **Security:** no findings above low. See `plan/current/security-report.md`.
3. **Execution:** all 12 acceptance criteria are `verified`, none `not-verifiable`. See `plan/current/verification-report.md`. No Codex program was available, so the hooks.json shape and exit 2 contract rest on the Codex docs.
4. **Deviation:** the queued backlog entries 0000210 to 0000212 were committed by mistake and untracked in a later commit. They stay untracked for step 13.
