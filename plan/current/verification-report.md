# Verification report - 0000250-initiative-mid-run-changes

**Method.** I ran both new test files against the working tree. The driver test runs the real driver against a stub `claude` in temporary git repositories. I read the changed skill and standards sections. I listed the branch diff for hooks.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the skill holds the routing rule | `test-0000250-req-001` | verified | The Repo instructions during a run section names `plan/current-initiative/initiative.md`, the current or next pending step, the held lock, and says the skill never writes the override |
| REQ-001 AC-2 the skill holds the restart rule | `test-0000250-req-001` | verified | The Stops section names the `Restart:` line and tells the skill to start a new driver and watcher without asking |
| REQ-001 AC-3 the hook stays unchanged | `git diff --name-only` against the initiative branch, filtered for `hooks/`, `merge-guard`, and `gate-write` | verified | No match |
| REQ-002 AC-1 a driver change stops the driver | `test-0000250-req-002` | verified | The driver exited 1 with `I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs.` and started no step 2. A second driver then ran step 2 and finished |
| REQ-002 AC-2 a watcher or skill change stops the driver | `test-0000250-req-002` | verified | The driver exited 1 and named the watcher, the skill, and both files in a two-file change |
| REQ-002 AC-3 no change gives no restart | `test-0000250-req-002` | verified | A step that changed another skill, and a step that changed nothing, ran step 2 with no restart line. A final step and a root with no git also gave none |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,540 lines against 1,720 |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 217 feature suites passed, 2 failed, and 19 regression suites passed. The two failures are `test-0000042-req-006` and `test-0000043-req-009`. Both read the git-ignored step log (entry 0000264). Both pass on a clean `git archive` of `HEAD`, with 12 of 12 and 25 of 25 checks. No change here causes them.
