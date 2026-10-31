# Build report - 0000243-session-start-detection

**Run speed:** standard

| Phase | Agents | Model tier | Wall clock |
|-------|--------|------------|------------|
| P0 Discovery | 0 | primary | 17 min |
| P1 Plan | 0 | primary | 10 min |
| P2 Implement | 3 | primary and cheaper | 34 min |
| P3 Validate | 0 | primary | 9 min |
| P4 Ship | 0 | primary | 14 min |

## Parallelism

P2 ran U-001 in a subagent beside U-003 inline. A third subagent repointed ten older tests. U-002 ran after U-001, because the hook runs the script.

## Self-corrections

Two rework cycles, both avoidable. The size test mutation check and ten older tests assumed Resume Detection text lives in `SKILL.md`. A search for tests that read the section before the move would have found them.

## Improvement suggestions

- P2: find every test that reads a section before moving it. Backlog entry 0000261 files a shared helper.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000243-session-start-detection-2026-10-28.md
