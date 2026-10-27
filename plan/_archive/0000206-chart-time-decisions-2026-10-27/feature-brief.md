---
title: "Feature Brief - chart-time decisions"
summary: "Extend chart-time approval from schema and dependencies to the forks that stop a step."
status: "approved"
version: "0.1.0"
---
# Feature Brief - chart-time decisions

**Feature ID:** 0000206-chart-time-decisions

## Business Goal

Roadmap 0000168 stopped step 3 for four human decisions that Chart could have taken up front. A step also failed in CI on a PowerShell bug that P3 passed locally, because the machine had no `pwsh`. Chart pre-approves schema changes and dependencies today, and no other decision. Source: backlog entry 0000186.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Decision table | As the human on the loop, I approve a pre-mortem decision table at Chart, with a pre-approved answer, fallback scope, and bump effect for each likely fork, so that a step applies the answer without stopping. | must-have | 1 |
| Target checks | As the human on the loop, I see a baseline for each performance target, a criterion critic result for each measurable criterion, and an environment check for each step at Chart, so that a target rests on measured cost and a margin that covers noise. | must-have | 1 |
| Step application | As the human on the loop, I see a step apply a matching table row, log it, and stop only for a fork the table doesn't cover, so that a forecast fork needs no human. | must-have | 1 |
| Past stops | As the human on the loop, I see Chart turn each stop in the latest retrospectives into a table row, so that a stop does not repeat. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, scripts, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown and Bash |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A Chart-time decisions section in `roadmap-standards.md`: pre-mortem decision table, baseline before a performance target, criterion critic, pre-approved fallbacks, bump rule, environment check, and the retrospective input. A worked example replays the four roadmap 0000168 stops.
- Three new tables in `initiative.template.md`: `## Decisions`, `## Baselines`, and `## Criteria`.
- The step side: I-C Run applies a matching row and logs it, and a CI-only criterion marks the step validated only after its first CI run.
- The initiative skill and the orchestrator skill point to the new rules.
- Tests and living docs.

### Out of Scope
- A script that builds or validates the tables.
- Replacing the existing schema and dependency approvals.
- Driver changes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text budget | The skill text total stays at or under 1720 lines | The five-phases test counts the lines |

## Constraints and Assumptions

### Constraints
- Markdown and Bash only. No new dependency. No schema change.
- New prose passes the pack prose and em dash guards.

### Assumptions
- Step sessions already read `initiative.md`, so the new tables need no new read path.

## Scenario Paths

**Happy path:** At Chart, the initiative skill builds the three tables with the human. A step meets a forecast fork, applies the row, logs `Decision applied (initiative chart): {fork}`, and carries on.

> Self-confirmed (initiative).

**First-run path:** An initiative charted before this feature has no new tables. A step treats a missing table as an empty one and stops for any fork, as today.

> Self-confirmed (initiative).

**Error / sad path:** A fork that no row covers stops the step with `Blocked:`, as before.

> Self-confirmed (initiative).

**Cross-session continuity:** The tables live in `initiative.md`, which every step session reads, and the applied decision lands in the build log.

> Self-confirmed (initiative).

## Acceptance Criteria

- [ ] `initiative.template.md` holds a `## Decisions` table, a `## Baselines` table, and a `## Criteria` table.
- [ ] `roadmap-standards.md` states the pre-mortem, baseline, criterion critic, fallback, bump rule, environment check, and retrospective input rules.
- [ ] I-C Run tells a step to apply a matching row, log it, and stop only for an uncovered fork.
- [ ] The worked example shows each of the four roadmap 0000168 step 3 stops answered by a row.
