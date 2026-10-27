# Build report - 0000202-improvement-loops

- **Run speed:** standard.
- **Agents and tiers:** 0 agents. Every unit was small Markdown or test text that shared wording, so all work ran inline on the primary tier (`sonnet`).
- **Wall clock:** P0 6 minutes, P1 9, P2 19, P3 3, P4 5. About 46 minutes in all.
- **Parallelism:** P1 and P2 wrote their files as batches of parallel writes. P3 and P4 ran inline. No subagent was dispatched, because a dispatch would cost more than the edits.
- **Self-corrections:** 1. The first draft added 23 lines to the skills and breached the line budget in test 0000031. The cycle steps moved to the dispatch standard. The cycle was avoidable if the P1 plan had checked the skills line count first.
- **Improvement, P1:** when a plan edits a skill, check the line budget in `test-0000031-req-003-five-phases.sh` and plan the text for the standards folder.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
