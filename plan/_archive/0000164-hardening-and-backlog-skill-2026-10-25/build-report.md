# Build report - 0000164-hardening-and-backlog-skill

Source: the archived `build-log.md` in this folder.

## Agents and tiers

| Phase | Agents | Tiers | Parallel batches |
|-------|--------|-------|------------------|
| P0 Discovery | 0 | none | 0 |
| P1 Plan | 5 | sonnet 4, haiku 1 | 2 |
| P2 Implement | 6 | sonnet 6 | 1 parallel batch, then two single agents |
| P3 Validate and Accept | 4 | sonnet 4 | 2 |
| P4 Ship | 0 | none | 0 |
| Total | 15 | sonnet 14, haiku 1 | |

The orchestrator ran on opus for the whole run.

## Parallelism

- P0 ran inline. Its reads were small, and the build log states the reason.
- P1 batch 1 drafted the requirements in two agents beside the scope, risk, and glossary agent. Batch 2 wrote the ADRs while the orchestrator wrote the execution plan. The requirement split ran alone, because it edited every requirement.
- P2 ran four TDD tracks at once on disjoint files. The docs agent and the REQ-011 agent ran alone, because each depended on the finished code.
- P3 ran verification and the security review at once. Cycle 2 ran two fix agents at once on disjoint files.
- P4 ran in sequence. Each step reads the output of the step before.

## Self-corrections

| Cycle | Fault | Avoidable? |
|-------|-------|------------|
| P1 | Five requirements had more than three criteria, and three references to 0000151 ADR-007 read as missing local ADRs. | Yes. 0000160's report suggested putting the check's rules in drafting prompts, and this run did not. |
| P2 | The REQ-007 test needed `CLAUDE.md`, which is gitignored and absent in CI. | Yes. The plan did not note that `CLAUDE.md` is untracked. |
| P2 | The longer `gate-write` bullet broke the 0000151 size budget for `CLAUDE.md` plus the orchestrator `SKILL.md`. | Partly. Tracks ran only their own suites, so the budget suite ran late. |
| P3 cycle 1 | The size budget failed again, because setup copies `standard-boot.md` into `CLAUDE.md`. | Yes. The P2 fix changed only `CLAUDE.md`, not its source template. |
| P3 cycle 2 | Security: two medium findings (silent hook-entry removal, unvalidated slug) and three low ones. | Partly. The REQ-005 criteria named no input validation. |

## Deviations

- Track C found that only the telemetry cleanup removed a retired hook's `settings.json` entry. Hook install now does it for any retired hook. ADR-003 records it.
- In P3 the human reversed the version decision. The run became 0.13.0, 0000160 became 0.12.0, and ADR-005 and REQ-011 were added. The human overrode the downgrade block.
- PR #27 opened as a draft in P3, so CI could run the PowerShell suites. `pwsh` is not installed locally.
- A security review agent ran `setup.sh` against the real repo by mistake. It changed only a timestamp, which the agent reverted.
- Parallel tracks shared one git index, so one commit swept in another track's staged deletions.

## Improvement suggestions

- **P0:** ask the version question on its own, never bundled with a scope question. 0000160 bundled it, and this run had to undo it.
- **P1:** put the consistency check's rules in every drafting prompt: at most three criteria, and no `ADR-NNN` token for another feature's ADR.
- **P2:** give each parallel track the cross-cutting suites to run, such as size budgets, prose lint, and skill counts. Name the template a generated file comes from.
- **P3:** warn every agent that `setup.sh` resolves the project from its own location, so it must run only on a copied pack.
