# Acceptance evidence - 0000246-plan-checks-count-and-cap-tests

## Checks

- Feature suites: 209 passed, 2 failed in the working tree. Both failures come from the git-ignored step log (entry 0000264) and pass on a clean archive of `HEAD`.
- Regression suite: 19 passed, 0 failed.
- Self-corrections: 1 test fix. The new test's needle case and an order assertion changed before the first green run.

## Security

No findings. See `security-report.md`.

## Execution

- `test-0000246-req-001` passes 9 of 9 on the tree and fails 9 of 9 when both headings are renamed.
- Skill text measures 1,509 lines against the 1,720 line cap.
- Not verifiable: none.
