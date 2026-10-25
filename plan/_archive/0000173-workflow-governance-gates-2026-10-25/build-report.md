# Build report - 0000173-workflow-governance-gates

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 5.

**Run speed:** `standard`. The roadmap has no `**Speed:**` field.

## Agents, tiers, and time

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 Discovery | 0 | primary orchestrator | 0 | 1 min |
| P1 Plan | 1 | cheaper (haiku) | 1 | 1 min |
| P2 Implement | 2 | primary (sonnet) | 1 | 12 min |
| P3 Validate and Accept | 2 | primary (sonnet) | 1 | 8 min |
| P4 Ship | 0 | primary orchestrator | 0 | 0 min to Step 3 |

Total wall clock to Step 3 of P4 was 25 minutes. Times round down to whole minutes.

## Parallelism

- P1 ran the scope agent while the orchestrator wrote the story map, requirements, ADRs, and execution plan. The requirements share one marker design, so one writer kept them in step.
- P2 ran tracks A and B together on disjoint files. The orchestrator updated the living docs, the component manifest, and the pipeline reference meanwhile.
- P3 ran verification and the security review together, with the full suite in the background.
- P0 and P4 ran in sequence. Each P0 read fed the next, and ship runs in order by design.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P3 | Three low security findings: a free-text failure reason in the PR body, an unquoted folder, and non-file loop-state entries. One commit mitigated all three. | Partly. A security note in the REQ-004 brief on public PR text would have set a fixed reason from the start. |

## Deviations

- REQ-003: the orchestrator `Gate revised: P{N}` line is short and names no standard, to fit the 0000151 size budget.
- REQ-001: the standard lists marker forms as bullets, and a rework tie names the lower requirement id.

## Improvement suggestions

- P2: the orchestrator `SKILL.md` and `CLAUDE.md` pair now has 10 bytes of headroom under its budget. The next rule that touches the orchestrator should go to a reference file.
- P3: run the security review against the requirement drafts in P1 for any text that reaches a public PR.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
