# Acceptance evidence - 0000251-driver-step-fixes

## Checks

- Feature suites: 218 passed, 3 failed in the first full run. Regression suite: 19 passed, 0 failed.
- Two failures are `test-0000042-req-006` and `test-0000043-req-009`. They scan the git-ignored step log (entry 0000264) and pass on a clean archive of `HEAD`.
- The third failure was the new req-001 test under `RAVINTIO_TEST_QUIET=1`. The test now unsets the variable and passes 8 of 8 in a quiet run.
- Self-corrections: 1.

## Security

No findings. See `security-report.md`.

## Execution

- Both runners give a probe suite an unset `RAVINTIO_INITIATIVE_STEP`, with the variable set to `1` on entry.
- A step that runs three times leaves `attempt-1`, `attempt-2`, and a current log, each with its own output and each attempt at mode 600. A symlink at an attempt path stops the driver.
- The stop line names the earlier attempts after `Earlier:` and ends with `Log:`.
- The branch diff holds no change to a hook, `merge-guard`, or `gate-write`.
- The running driver predates this change, so a re-run under it still truncates. Restart the driver and the watcher to load the new code.
- Not verifiable: none.
- Searches for missing programs: none were needed. `command -v node git pwsh` found all three.
