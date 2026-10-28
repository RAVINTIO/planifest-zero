# Verification report - 0000247-git-state-hygiene

**Method.** I ran the three new test files against the working tree. I then ran them against an archive of the commit before the implementation, to prove each test detects a missing rule. I also ran `reserve-id.mjs --commit` in temp repositories.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 orchestrator carries the rule | `test-0000247-req-001` | verified | 10 of 10 checks pass |
| REQ-001 AC-2 ship skill carries the rule | `test-0000247-req-001` | verified | Step 4 names the explicit paths and the ban |
| REQ-001 AC-3 orchestrator under its cap | `test-0000247-req-001`, `test-0000151-req-011` | verified | 8,098 bytes against 9,000 |
| REQ-002 AC-1 counter in its own commit | Invoke the script in a temp repo with a second staged file | verified | The new commit holds `plan/backlog/.next-id` alone and the other file stays staged |
| REQ-002 AC-2 failure keeps the counter | Invoke the script outside a git repository | verified | Exit 1, one stderr line, counter holds the new value |
| REQ-002 AC-3 three skills carry the rule | `test-0000247-req-002` | verified | Initiative, retrospective, and postmortem each name `reserve-id.mjs --commit` |
| REQ-003 AC-1 rule and reason | `test-0000247-req-003` | verified | `## Fast batches` forbids `git stash` and gives the reason |
| REQ-003 AC-2 skeleton prompts | `test-0000247-req-003` | verified | Both prompts forbid `git stash` |
| REQ-003 AC-3 resume stash kept | `test-0000247-req-003` | verified | `git stash push --include-untracked` remains |
| Tests detect a missing rule | Run the new tests on an archive of the commit before the implementation | verified | 2 of 10, 3 of 15, and 2 of 5 checks pass, so the rest fail |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,512 lines against 1,720 |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 214 feature suites and 19 regression suites with 0 failures. The first run failed 3 suites. Two read `plan/.initiative-logs/step-8.log`, which is git-ignored (entry 0000264). The third failed because the rule changed Hard Limit 8's line. I moved the rule to its own line. I ran the final suite with `plan/.initiative-logs/` moved aside for the run and restored afterward.
