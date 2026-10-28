# Acceptance evidence - 0000248-ship-merge-and-wall-clocks

## Checks

- Feature suites: 214 passed, 2 failed. Regression suite: 19 passed, 0 failed.
- The two failures are `test-0000042-req-006` and `test-0000043-req-009`. They scan the git-ignored step log (entry 0000264) and pass on a clean archive of `HEAD`.
- Self-corrections: 0.

## Security

No findings. See `security-report.md`.

## Execution

- The two new test files pass 8 of 8 and 22 of 22 checks.
- `build-log-check.mjs` fails the archived 0000206 log for a blank P1 `End`, a blank P1 `Wall clock`, and a P0 `Wall clock` of 0 against 2.4 minutes. It passes the complete 0000247 log.
- `merge-guard` allows `gh pr merge --squash --delete-branch 52` for an `initiative/*` base. The branch diff holds no change to `merge-guard.mjs` or its test.
- Skill text measures 1,526 lines against the 1,720 line cap.
- Not verifiable: none.
