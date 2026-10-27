# Build report - 0000197-merge-guard-block-message

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Self-corrections |
|-------|--------|------------|----------------------|------------------|
| P0 Discovery | 0 | primary | 3 | 0 |
| P1 Plan | 0 | primary | 8 | 0 |
| P2 Implement | 0 | primary | 12 | 0 |
| P3 Validate and Accept | 0 | primary | 6 | 0 |
| P4 Ship | 0 | primary | 9 | 0 |

## Parallelism

None used. The feature has one requirement that edits three strings, so the phases ran in one context.

## Self-corrections

None.

## Observations

- Two shell commands that named the merge words in text were blocked by the old message. The first reproduced backlog entry 0000190. The second was a `grep` pattern. Both were avoided with the Write tool or by rewording the pattern.

## Improvement suggestions

- P0: write long artifacts with the Write tool from the start. A heredoc that names the merge command blocks, and this feature now says so.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
