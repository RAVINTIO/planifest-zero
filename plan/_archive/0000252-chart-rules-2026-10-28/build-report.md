# Build report - 0000252-chart-rules

**Run speed:** standard

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 10 | 0 | primary | 0 |
| P3 Validate and Accept | 0 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. Five units of short Markdown edits, so I ran them inline. A subagent costs more than the edits.

**Self-corrections.** 1 rework cycle, in REQ-001. A skill test needle matched a capitalised heading, so I changed the skill wording. I also typed the P0 end time and the P1 end time ahead of the clock and corrected both before the next phase closed (entry 0000266). The correction was avoidable: read the clock when you write a time.

**Improvements.**
- P0: read `date -u` when you write a timestamp, and do not type one (entry 0000266).
- P2: the full suite takes about 8 minutes. Run the affected suites during P2 and the full suite once at P3.
- P3: keep the step log out of the stale cite guard (entry 0000264). It failed the same two suites again.

**Restart needed.** This step edits `ravintio-initiative/SKILL.md`, so the driver stops with `I-D Advance: Restart:` after the merge. The initiative skill starts a new driver and a new watcher.

**Postmortems:** none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000252-chart-rules-2026-10-28.md
