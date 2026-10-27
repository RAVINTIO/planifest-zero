# Build report - 0000196-setup-argument-checks

**Run speed:** standard

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|-----------|----------------------|
| P0 Discovery | 0 | primary | 39 |
| P1 Plan | 0 | primary | 28 |
| P2 Implement | 0 | primary | 65 |
| P3 Validate and Accept | 0 | primary | 25 |
| P4 Ship | 0 | primary | 20 |

## Parallelism

None used. REQ-001 and REQ-002 edit the same lines of both setup scripts, and REQ-003 words its report from REQ-002. The plan artifacts were small and shared one context.

## Self-corrections

- A test grep for the exact tool match needed the `-ccontains` form. Avoidable: no, an older test pinned the wording.
- Two guard tests flagged the earlier product name in new test files. Avoidable: yes, the guards were known.

## Suggestions

- P1: state which backlog claims (exit code for a missing tool, count of tests to change) need a check against the code before the brief is written.
- P2: run the brand and old-name guards after the first new test file.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 1 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
