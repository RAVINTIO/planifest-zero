# Build report - 0000244-split-orchestrator-skill

**Run speed:** standard

| Phase | Agents | Model tier | Wall clock |
|-------|--------|------------|------------|
| P0 Discovery | 0 | primary | 5 min |
| P1 Plan | 0 | primary | 1 min |
| P2 Implement | 0 | primary | 30 min |
| P3 Validate | 0 | primary | 5 min |
| P4 Ship | 0 | primary | 12 min |

## Parallelism

None. SKILL.md was the shared write target of every move, so the units ran in order and inline.

## Self-corrections

Two rework cycles, both avoidable. 32 suites read moved text from `SKILL.md`, and a forced `git add` committed driver files. A search for tests that read the sections before the move would have found the suites.

## Improvement suggestions

- P2: find every test that reads a section before moving it. Backlog entry 0000261 covers a shared helper.
- P0: stage by path. Backlog entry 0000213 covers it.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-004) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000244-split-orchestrator-skill-2026-10-28.md
