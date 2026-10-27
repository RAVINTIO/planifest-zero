# Build report - 0000201-plan-concurrent-work

- **Run speed:** standard.
- **Agents and tiers:** 3 agents, all primary tier (`sonnet`). They ran U1, U2, and U3 as one parallel batch.
- **Wall clock:** P0 6 minutes, P1 10, P2 8, P3 3, P4 6. About 40 minutes in all.
- **Parallelism:** P2 dispatched the three units of batch 1 in one message, as the new concurrency plan laid out. P1 wrote its artifacts as one batch of parallel writes. P3 and P4 ran inline.
- **Self-corrections:** 1. The mid-pipeline reference edit changed a line that a 0000151 suite guards. The sentence moved to its own line. The cycle was avoidable if the unit brief had named that suite.
- **Improvement, P2:** name the guard suites that read an edited file in the unit brief.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
