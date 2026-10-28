# Build report - 0000250-initiative-mid-run-changes

**Run speed:** standard

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 10 | 0 | primary | 0 |
| P3 Validate and Accept | 1 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. Three small units of short edits, so I ran them inline. A subagent costs more than the edits.

**Self-corrections.** 0 rework cycles. I did correct two build log times that I had typed ahead of the clock, before the first phase closed (entry 0000266). The correction was avoidable: read the clock when you write a time.

**Improvements.**
- P0: read `date -u` when you write a timestamp, and do not type one (entry 0000266).
- P2: the full suite takes about 9 minutes. Run the affected suites during P2 and the full suite once at P3.
- P3: keep the step log out of the stale cite guard (entry 0000264). It failed the same two suites again.

**Restart needed.** The running driver predates this change, so it does not stop after step 12. Restart the driver and the watcher so steps 13 to 15 run the new code. The new driver stops after any later step that changes the driver, the watcher, or the initiative skill.

**Postmortems:** none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000250-initiative-mid-run-changes-2026-10-28.md
