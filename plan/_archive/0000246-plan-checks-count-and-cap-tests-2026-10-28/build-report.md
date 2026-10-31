# Build report - 0000246-plan-checks-count-and-cap-tests

**Run speed:** standard

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 4 | 0 | primary | 0 |
| P2 Implement | 9 | 0 | primary | 0 |
| P3 Validate and Accept | 7 | 0 | primary | 0 |
| P4 Ship | 8 | 0 | primary | 0 |

**Parallelism.** None. U-001 and U-002 shared one batch in the plan, but both were small edits to three files, so I ran them inline rather than pay for subagent set-up.

**Self-corrections.** 1 rework cycle. The new test used lower-case needles against capitalised bullet labels, and one order assertion passed when the section was missing. Both were avoidable by a closer read of `assert_contains`.

**Improvements.**
- P2: write an order check with `assert_equals`, not `assert_contains`, since a substring match passes on the wrong value.
- P3: keep the step log out of the stale cite guard (entry 0000264). It failed two suites again.

**Postmortems:** none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000246-plan-checks-count-and-cap-tests-2026-10-28.md
