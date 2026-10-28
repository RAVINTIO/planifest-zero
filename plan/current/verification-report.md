# Verification report - 0000249-check-path-before-missing-claims

**Method.** I ran the new test file against the working tree and the five existing suites that read the edited skill. I read the changed sections of the skill. I listed the branch diff for hooks.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the skill holds the PATH search rule | `test-0000249-req-001` | verified | The Verify by execution section holds `command -v {program}`, the "before a report says a program is missing" trigger, and the three install folders |
| REQ-001 AC-2 the skill defines the docs-only status | `test-0000249-req-001` | verified | The outcomes list defines `unverified (docs only)`, says it rests on documentation alone, and says it never counts as `verified` |
| REQ-001 AC-3 the evidence rules ask for the search and the list | `test-0000249-req-001` | verified | The Acceptance gate item 4 asks for the `PATH` check commands and each unverified claim by name. The section keeps its ban on raw command output |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,530 lines against 1,720 |
| No hook change | `git diff --name-only` against the initiative branch, filtered for `hooks/`, `merge-guard`, and `gate-write` | verified | No match |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 215 feature suites and 19 regression suites. Two feature suites failed, `test-0000042-req-006` and `test-0000043-req-009`. Both read the git-ignored step log (entry 0000264). Both pass on a clean `git archive` of `HEAD`, with 12 of 12 and 25 of 25 checks. No change here causes them.
