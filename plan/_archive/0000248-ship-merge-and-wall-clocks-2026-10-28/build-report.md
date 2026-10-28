# Build report - 0000248-ship-merge-and-wall-clocks

**Run speed:** standard

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 2 | 0 | primary | 0 |
| P2 Implement | 26 | 0 | primary | 0 |
| P3 Validate and Accept | 9 | 0 | primary | 0 |
| P4 Ship | 1 | 0 | primary | 0 |

**Parallelism.** None. U-001 and U-002 sat in two batches because U-002 names U-001's script. Each unit was a few short edits, so I ran them inline.

**Self-corrections.** 0 rework cycles.

**Improvements.**
- P2: a shell command that names the merge line in text, such as a heredoc, trips `merge-guard`. It stopped one shell write in P0 and one in P2. The Write and Edit tools avoid it. Entry 0000197 covers the message, not the cause.
- P3: keep the step log out of the stale cite guard (entry 0000264). It failed the same two suites again.
- P4: the P4 `End` is written at Step 3, before the archive, so the P4 wall clock leaves out the PR and CI wait. The new check accepts this. A later change could record the CI wait in the PR or the retrospective.

**Postmortems:** none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000248-ship-merge-and-wall-clocks-2026-10-28.md
