# Build report - 0000206-chart-time-decisions

**Run speed:** standard

| Phase | Model tier | Agents | Wall clock | Notes |
|-------|-----------|--------|-----------|-------|
| P0 Discovery | primary | 0 | not recorded | Self-confirmed design |
| P1 Plan | primary | 0 | not recorded | Consistency check clean |
| P2 Implement | primary | 0 | not recorded | Inline TDD, two suites |
| P3 Validate and Accept | primary | 0 | not recorded | One known failure, `test-0000151-req-014` |
| P4 Ship | primary | 0 | not recorded | Merge into the initiative branch |

**Parallelism:** none. U2 depended on U1 and both edit one standards file, so no batch ran in parallel.

**Self-corrections:** 1, avoidable. The orchestrator skill passed its size cap by 39 bytes because the first pointer line was long. Checking `wc -c` before the full suite would have caught it.

**Improvements:** P3 would save time if the installed-copies check skipped itself during an active initiative.

**Postmortems:** none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000206-chart-time-decisions-2026-10-27.md
