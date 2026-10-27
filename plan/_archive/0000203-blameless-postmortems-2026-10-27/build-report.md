# Build report - 0000203-blameless-postmortems

- **Run speed:** standard.
- **Agents and tiers:** 0 agents. Every unit was small Markdown or test text that shared wording, so all work ran inline on the primary tier (`sonnet`).
- **Wall clock:** P0 4 minutes, P1 9, P2 17, P3 3, P4 5. About 38 minutes in all.
- **Parallelism:** P1 and P2 wrote their files as batches of parallel writes. P3 and P4 ran inline. No subagent was dispatched, because a dispatch would cost more than the edits.
- **Self-corrections:** 2. The first test run failed on capitalised action types in the skill, which was avoidable. The skill count and the line budget in tests 0000031 and 0000160 changed because a skill was added, which a P1 grep for the count would have found.
- **Improvement, P1:** when a plan adds a skill, grep the tests for the skill count and the skill-text line budget, and list those files in the plan.
- **Postmortems:** none.
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
