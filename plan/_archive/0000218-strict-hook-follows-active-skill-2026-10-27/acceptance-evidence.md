# Acceptance evidence - 0000218-strict-hook-follows-active-skill

1. **Checks:** the Bash runner passed 199 feature suites and 19 regression checks, run inside a step session with `RAVINTIO_INITIATIVE_STEP=1` set. The new suite `test-0000218-req-001-002-skill-owner-banner.sh` failed 12 assertions before the fix and passes 44 after it. No self-correct cycle ran. The PowerShell runner passed 19 suites under `pwsh`.
2. **Security:** no finding above informational. See `security-report.md`.
3. **Execution:** see `verification-report.md`.

| Criterion | Result |
|-----------|--------|
| AC-1 initiative banner, lock free | Verified |
| AC-2 initiative banner, lock held | Verified |
| AC-3 step session gets the orchestrator | Verified |
| AC-4 no initiative gets the orchestrator | Verified |
| AC-5 both hooks name the same skill | Verified |
| AC-6 `plan/.initiative-ack` git-ignored | Verified |

4. **Deviation:** the auto-trigger hook no longer requires an empty `plan/current/`, and the 0000205 hook suite changed to match. Both suites now clear `RAVINTIO_INITIATIVE_STEP`.
