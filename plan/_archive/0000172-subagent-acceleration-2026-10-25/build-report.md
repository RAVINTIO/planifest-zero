# Build report - 0000172-subagent-acceleration

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 4.

**Run speed:** `standard`. The run predates `plan/.run-speed`, so it ran at the default.

## Agents, tiers, and time

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 Discovery | 0 | primary orchestrator | 0 | 0 min |
| P1 Plan | 1 | cheaper (haiku) | 1 | 1 min |
| P2 Implement | 2 | primary (sonnet) | 1 | 25 min |
| P3 Validate and Accept | 2 | primary (sonnet) | 1 | 12 min |
| P4 Ship | 0 | primary orchestrator | 0 | 0 min to Step 3 |

Total wall clock to Step 3 of P4 was 41 minutes. Times round down to whole minutes. The P0 and P1 `End` rows come from commit times, filled after the fact.

## Parallelism

- P1 ran the scope agent while the orchestrator wrote the story map, requirements, ADRs, and execution plan. The requirements share one design, so one writer kept them in step.
- P2 ran tracks A and B together on disjoint files. The orchestrator wrote REQ-001 and the orchestrator and ship lines meanwhile.
- P3 ran verification and the security review together.
- P0 and P4 ran in sequence. Each P0 read fed the next, and ship runs in order by design.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P2 | Five suites failed after batch 1. The orchestrator `SKILL.md` passed its size budget and changed three base lines. Ship Step 8 lost wording a suite reads. Two backlog entries named the other product as "Framework" alone. One commit fixed all five. | Yes. A check of `test-0000151-req-011` before editing the orchestrator would have sent the new rules to a reference file first. |
| P3 | The security review found three medium gaps in the new fast batch rules: a stop in one unit, shared dependency manifests, and concurrent commits. | Partly. The REQ-002 brief named disjoint files but not the git index or lock files. |

## Deviations

- REQ-001: the run-speed question and rules live in `references/orchestrator-run-speed.md`, not in `SKILL.md`.

## Improvement suggestions

- P0: a hand-written timestamp ran ahead of the clock and needed a fix commit. Take each timestamp from `date -u` or the commit time.
- P2: another session committed backlog entries on the feature branch while the step ran. Backlog 0000182 covers where those entries should go.
- P4: a fast run would batch Steps 5 and 6. This run was `standard`, so it ran them in order.
