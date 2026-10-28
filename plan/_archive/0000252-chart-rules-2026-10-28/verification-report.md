# Verification report - 0000252-chart-rules

**Method.** I ran the three new test files against the working tree. I read the changed standards, template, skill, and reference sections. I listed the branch diff for hooks and counted skill lines.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the standard holds the guard check | `test-0000252-req-001` | verified | The I-A Chart section names `merge-guard`, `gate-write`, `ratchet-check`, and any other fail-closed hook, the new forms, and a separate approval for each widening |
| REQ-001 AC-2 the skill holds the same rule | `test-0000252-req-001` | verified | The Chart section of `ravintio-initiative/SKILL.md` names the guard check and a separate approval |
| REQ-001 AC-3 the hooks stay unchanged | `git diff --name-only` against the initiative branch, filtered for `hooks/`, `merge-guard`, and `gate-write` | verified | 0 matches |
| REQ-002 AC-1 the standard holds the confirmation rule | `test-0000252-req-002` | verified | The Chart-time confirmations subsection lists each confirmation, the exact command pre-approval, and the human stop |
| REQ-002 AC-2 the template has a confirmation row form | `test-0000252-req-002` | verified | The `## Decisions` table holds a row whose Fork starts with `Confirmation:` |
| REQ-002 AC-3 a pre-approved confirmation does not stop a step | `test-0000252-req-002` | verified | I-C Run runs a matching `Confirmation:` row with no stop and stops on a command that differs in any way |
| REQ-003 AC-1 the template has the P1 skip field | `test-0000252-req-003` | verified | `## P1 skips` sits between `## Criteria` and `## Steps`, and the `## Steps` header is unchanged |
| REQ-003 AC-2 the standard states which steps are skippable and the stop | `test-0000252-req-003` | verified | Chart allows `yes` for a chore with exact tasks or a change with no code, and I-C Run stops with `I-C Run: Blocked:` |
| REQ-003 AC-3 the build log names the chart row | `test-0000252-req-003` | verified | I-C Run and the Phase Skip Protocol reference both hold the `Skipped: P1` line with the chart row |
| Driver step count | `test-0000043-req-007-roadmap-driver.sh` | verified | 40 of 40 checks pass with the new template section present |
| Skill-text budget | `test-0000031-req-003-five-phases.sh` | verified | 1,545 lines against 1,720 |
| Orchestrator size cap | `test-0000151-req-011-orchestrator-references-split.sh` | verified | `SKILL.md` holds 8,098 bytes against 9,000. The suite passes 110 of 110 checks |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 224 feature suites and 19 regression suites. 222 feature suites passed and 2 failed. The two failures are `test-0000042-req-006` and `test-0000043-req-009`. Both read the git-ignored step log (entry 0000264). Both pass on a clean `git archive` of `HEAD`, with 12 of 12 and 25 of 25 checks. No change here causes them.
