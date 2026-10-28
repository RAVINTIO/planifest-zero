# Acceptance evidence - 0000245-boot-rules-into-skills

## Checks

- Feature suites: 208 passed, 2 failed in the working tree. Both failures come from the git-ignored step log and pass on a clean archive of `HEAD`.
- Regression suite: 19 passed, 0 failed.
- Self-corrections: 5 test rework cycles (suites 0000009, 0000164, 0000200, 0000207, and the cap test in 0000151 req-011).

## Security

No critical or high findings. One medium finding, the `target:` path check, is mitigated. See `security-report.md`.

## Execution

- Setup run twice in a temporary project: `CLAUDE.md` measures 4,701 bytes against a 6,000 byte cap.
- `gutd` and `delete-redundant-branches` install. The ship, refresh-setup, and orchestrator skills each hold one override block, and the boot file holds none of the three rules.
- Not verifiable: none.
