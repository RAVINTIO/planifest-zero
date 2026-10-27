# Build report - 0000199-reserve-ids-from-counter

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Parallelism |
|-------|--------|------------|----------------------|-------------|
| P0 Discovery | 0 | primary | 8 | none |
| P1 Plan | 0 | primary | 8 | none |
| P2 Implement | 0 | primary | 17 | none |
| P3 Validate and Accept | 0 | primary | 4 | none |
| P4 Ship | 0 | primary | 9 | none |

Phase times from P2 on are estimates read from the session clock.

## Parallelism

None used. The three requirements share one new test file and the doc edits are small, so subagent overhead exceeds the work. P2 ran the TDD loop inline.

## Self-corrections

1. `reserve-id.mjs` called `process.exit` inside a `try`, which skipped the `finally` and left the lock behind after a failure. Avoidable: a failure-path test written before the code would have caught it. The suite now checks the folder after each failure.

## Improvement suggestions

- P1: the consistency check's cap of 3 criteria per requirement forced a split after the first draft. Draft requirements with at most 3 criteria from the start.
- P2: four suites asserted wording the change replaced. Search the tests for the old phrases before editing the docs.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
