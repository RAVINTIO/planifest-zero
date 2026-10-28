# Verification report - 0000248-ship-merge-and-wall-clocks

**Method.** I ran the two new test files against the working tree. I ran `build-log-check.mjs` on real archived build logs. I listed the branch diff against the initiative branch for `merge-guard`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 ship skill holds the line and the rule | `test-0000248-req-001` | verified | The Initiative steps section holds the line, the literal PR number rule, and the ban. I-D Advance step 4 holds the same wording |
| REQ-001 AC-2 merge-guard allows the line | `test-0000248-req-001` with a stub `gh` | verified | `gh pr merge --squash --delete-branch 52` exits 0 for an `initiative/x` base and exits 2 for `main` |
| REQ-001 AC-3 merge-guard unchanged | `git diff --name-only origin/initiative/0000238-backlog-clearance-two...HEAD` filtered for `merge-guard` | verified | No match. Neither `merge-guard.mjs` nor `test-0000043-req-006-merge-guard-hook.sh` changed |
| REQ-002 AC-1 blank and wrong times fail | `test-0000248-req-002` and the script on `0000206` and `0000207` archives | verified | The 0000206 log exits 1 with P1 `End` blank, P1 `Wall clock` blank, and P0 `Wall clock` 0 against 2.4 minutes. The 0000207 log exits 1 for P0 |
| REQ-002 AC-2 missing block and total | `test-0000248-req-002` and the script on this run's log before P3 and P4 existed | verified | Exit 1 named P3, P4, and `Total wall clock`. A `Skipped: P2` line excuses a missing P2 block |
| REQ-002 AC-3 ship runs the check | `test-0000248-req-002`, and the script on the `0000247` archive | verified | Step 3 runs the script before Step 4 and stops on a failure. The complete `0000247` log prints `build-log-check: clean` |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,526 lines against 1,720 |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 214 feature suites and 19 regression suites. Two feature suites failed, `test-0000042-req-006` and `test-0000043-req-009`. Both read `plan/.initiative-logs/step-7.log`, which is git-ignored (entry 0000264). Both pass on a clean `git archive` of `HEAD`. No change here causes them.
