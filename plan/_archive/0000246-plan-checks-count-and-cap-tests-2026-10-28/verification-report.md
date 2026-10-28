# Verification report - 0000246-plan-checks-count-and-cap-tests

**Method.** I ran `test-0000246-req-001-test-impact-scan.sh` against the working tree. I then ran it against a copy of `HEAD` with both new headings renamed, to prove it detects a missing section.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 skill carries the scan | `test-0000246-req-001` | verified | 9 of 9 checks pass on the tree. The four causes, the tests path and `none found` are present |
| REQ-001 AC-2 template carries the section | `test-0000246-req-001` | verified | The `## Test impact` heading, the `Cause`, `Test` and `Unit` columns, and the order before `## Concurrency plan` pass |
| REQ-001 AC-3 scan stays small | Line count in the test | verified | The section holds 6 lines against a 15 line cap |
| Test detects a missing section | Mutation on a copy of `HEAD` | verified | With both headings renamed, 9 of 9 checks fail |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,509 lines against 1,720 |
| Template headings | `test-0000201-req-001-concurrency-section.sh` | verified | 28 of 28 checks pass |

**Not verifiable.** None.

**Test run.** `run-tests.sh` with `RAVINTIO_INITIATIVE_STEP` unset ran 209 feature suites clean and 2 failed. Those two, `test-0000042-req-006` and `test-0000043-req-009`, read `plan/.initiative-logs/step-7.log`, which is git-ignored. Both pass on a clean `git archive` of `HEAD`. Entry 0000264 already covers the cause. Regression suite: 19 of 19.
