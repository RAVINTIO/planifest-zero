# Build report - 0000192-rename-runner-lock-and-archive

> Sourced from the archived `build-log.md`.

**Run speed:** `fast`. The run was autonomous and had no stops.

## Agents, tiers, and time

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 Discovery | 0 | primary | 0 | 0m 48s |
| P1 Plan | 0 | primary | 0 | 1m 13s |
| P2 Implement | 0 | primary | 0 | 1m 32s |
| P3 Validate and Accept | 0 | primary | 1 | 4m 51s |
| P4 Ship | 0 | primary | 0 | 0m 21s (to the close of the log) |

Total: 8m 45s to the close of the log.

## Parallelism

- P3 ran the full Bash suite in the background beside the execution checks and the security review.
- P1 and P2 ran inline. The build log records the reason: each artifact was a few lines, and REQ-001 and REQ-002 share one script and one test.

## Self-corrections

- P1: plan files first named the old lock and folder pattern, which the guard now flags. I reworded them. Avoidable: the guard change was known before P1 began.
- P2 and P3: estimated phase times were replaced with commit times. Avoidable: read commit times before writing a phase block.

## Improvement suggestions

- P1: when a run removes old names, write plan files without them from the start.
- P2 to P4: take phase times from `git log` rather than estimating them.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
