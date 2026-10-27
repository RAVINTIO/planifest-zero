# Acceptance evidence - 0000217-verify-codex-setup

1. **Checks:** with `RAVINTIO_INITIATIVE_STEP` unset, the Bash runner passed 198 feature suites and 19 regression checks. The PowerShell runner passed 19 suites under `pwsh`. With the variable set, one suite fails, as in step 13: the hook ack tests read it from the step session. No self-correct cycle ran.
2. **Security:** no finding above medium. See `plan/current/security-report.md`.
3. **Execution:** Codex `codex-cli 0.163.0` in a fresh temp repo after `setup.sh codex`. See `plan/current/verification-report.md`.

| Criterion | Result |
|-----------|--------|
| AC-1 skills load | Verified. Codex named all 16 RAVINTIO skills from `.agents/skills/`. |
| AC-2 merge blocked | Failed as specified. The merge command exited 0 and the stub logged it, because Codex skips untrusted project hooks. Fixed as a documentation gap, and the post-trust block is unverified. |
| AC-3 evidence recorded | Verified. |
| AC-4 test and bump | Verified. Two new assertions fail before the fix and pass after it. The bump rises to minor (0.30.0). |

4. **Decision for the human:** trust the hook with `/hooks` in a Codex session in a repo set up with `setup.sh codex`, then ask Codex to run a merge command with a stub `gh` first on `PATH`. A run-through is the only way to verify the block, because no non-interactive trust is available without bypassing the trust control.
5. **Deviation:** AC-2 as written assumed Codex runs the hook on first use. The fix changed wording and tests only. It did not change hook wiring.
