# Acceptance evidence - 0000250-initiative-mid-run-changes

## Checks

- Feature suites: 217 passed, 2 failed. Regression suite: 19 passed, 0 failed.
- The two failures are `test-0000042-req-006` and `test-0000043-req-009`. They scan the git-ignored step log (entry 0000264) and pass on a clean archive of `HEAD`.
- Self-corrections: 0.

## Security

No findings. See `security-report.md`.

## Execution

- The routing and restart rules test passes 10 of 10 checks. The driver restart stop test passes 21 of 21.
- The driver stops with `I-D Advance: Restart:` after a step that changes `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill, and names the files. A step that changes none gives no restart.
- Skill text measures 1,540 lines against the 1,720 line cap.
- The branch diff holds no change to a hook, `merge-guard`, or `gate-write`.
- The running driver predates this change, so it does not stop after this step. Restart the driver and the watcher to load the new code.
- Not verifiable: none.
- Searches for missing programs: none were needed. `command -v node git` found both.
