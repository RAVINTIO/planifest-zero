# Build report - 0000249-check-path-before-missing-claims

**Run speed:** standard

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 9 | 0 | primary | 0 |
| P3 Validate and Accept | 0 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. One requirement and one unit of short edits, so I ran it inline.

**Self-corrections.** 1 rework cycle. It was avoidable: a capital letter in the new Acceptance gate item did not match the test string.

**Improvements.**
- P2: the full suite takes about 8 minutes and inflates the P2 wall clock. Run only the affected suites during P2, and the full suite once at P3.
- P3: keep the step log out of the stale cite guard (entry 0000264). It failed the same two suites again.
- P4: the P4 `End` is written at Step 3, before the archive, so the P4 wall clock leaves out the PR and CI wait.

**Postmortems:** none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000249-check-path-before-missing-claims-2026-10-28.md
