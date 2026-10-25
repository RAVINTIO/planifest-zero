# Build report - 0000185-explain-strict-mode

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 6.

**Run speed:** `standard`. The roadmap has no `**Speed:**` field.

## Agents, tiers, and time

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 Discovery | 0 | primary orchestrator | 0 | 3 min |
| P1 Plan | 0 | primary orchestrator | 0 | 4 min |
| P2 Implement | 0 | primary orchestrator | 0 | 6 min |
| P3 Validate and Accept | 1 | primary (sonnet) | 1 | 5 min |
| P4 Ship | 0 | primary orchestrator | 0 | 1 min to Step 3 |

Total wall clock to Step 3 of P4 was 19 minutes. Times round down to whole minutes.

## Parallelism

- P3 ran the verification agent while the orchestrator wrote the security report.
- P1 ran in sequence. The build log records that each artifact ran to a few lines, so subagent overhead would exceed the work.
- P2 ran one inline track. The build log records that REQ-002 links to the anchor REQ-001 keeps, and the change was under 40 lines.
- P0 and P4 ran in sequence. Each P0 read fed the next, and ship runs in order by design.

## Self-corrections

None. P2 ran the full suite once from the tests folder, and one suite failed on repo-relative paths. A rerun from the repo root passed. No code changed, so the build log records no cycle.

## Improvement suggestions

| Phase | Suggestion |
|-------|-----------|
| P0 | Check whether a backlog entry's target section already exists before drafting the design. The entry for this run assumed a missing section. |
| P2 | Run `run-tests.sh` from the repo root every time. Some suites resolve paths from the working directory. |

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
