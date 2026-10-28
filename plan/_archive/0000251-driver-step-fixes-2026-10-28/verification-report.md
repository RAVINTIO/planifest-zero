# Verification report - 0000251-driver-step-fixes

**Method.** I ran both new test files against the working tree, with `RAVINTIO_INITIATIVE_STEP=1` set as in a step session. The driver test runs the real driver against a stub `claude` in temporary folders. The runner test runs copies of both real runners over a probe suite. I listed the branch diff for hooks.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 a probe suite sees the variable unset | `test-0000251-req-001` | verified | A feature suite and a regression suite behind `run-tests.sh` both recorded `unset` |
| REQ-001 AC-2 the PowerShell runner clears it too | `test-0000251-req-001` with `pwsh` 7.6.8 | verified | A probe behind `run-tests.ps1` recorded `unset` |
| REQ-001 AC-3 the full suite gives the same result | `RAVINTIO_INITIATIVE_STEP=1 bash ravintio-zero/tests/run-tests.sh` | verified | No hook suite failed on the variable. The only failures were the two known ones below and a quiet-mode fault in the new test, which is fixed |
| REQ-002 AC-1 every run keeps the earlier logs | `test-0000251-req-002` | verified | Three runs left `attempt-1` and `attempt-2` with their own output, a current log with the third, and mode 600 on each attempt file. One run left only `step-1.log` |
| REQ-002 AC-2 a symlink at an attempt path stops the driver | `test-0000251-req-002` | verified | The driver exited 1 with the symlink refusal, left the victim file and the current log unchanged, and released the lock |
| REQ-002 AC-3 the stop line names the attempt logs | `test-0000251-req-002` | verified | The line carried `Earlier:` with both attempt paths in order and ended with `Log:` |
| Existing log rule | `test-0000151-req-012` | verified | 56 of 56 checks, with case (a) updated to the attempt rule |

**Not verifiable.** None.

**Test run.** The first full run held 218 feature suites passed and 3 failed. Two failures are `test-0000042-req-006` and `test-0000043-req-009`, which read the git-ignored step log (entry 0000264). Both pass on a clean `git archive` of `HEAD`, with 12 of 12 and 25 of 25 checks. The third failure was the new req-001 test, which broke when the outer run set `RAVINTIO_TEST_QUIET=1`. The test now unsets it and passes 8 of 8 in a quiet run.
