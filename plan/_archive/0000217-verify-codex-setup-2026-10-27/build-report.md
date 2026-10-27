# Build report - 0000217-verify-codex-setup

- Run speed: standard.
- Agents: 0 in every phase. No subagent ran, because the chore had one sequential unit of work and shared state.
- Model tier: primary throughout. Wall clock per phase: not recorded.
- Parallelism: none used. No multi-task phase ran sequentially.
- Self-corrections: 2, both avoidable (see the build-log summary).
- P1 skipped: the chart fixes the spec for this chore.
- Postmortems: none
- Retrospective: plan/retrospectives/0000217-verify-codex-setup-2026-10-27.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
