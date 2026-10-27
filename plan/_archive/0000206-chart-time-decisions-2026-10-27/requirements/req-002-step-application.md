# Requirement: REQ-002 - step-side application and skill pointers

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Version:** 0.28.0
**Source:** US-003
**Priority:** must-have

## User Story

As the human on the loop, I see a step apply a matching row, log it, and stop only for an uncovered fork, so that a forecast fork needs no human.

## Functional Requirements
- I-C Run in `roadmap-standards.md` tells a step to apply a matching `## Decisions` row, log `Decision applied (initiative chart): {fork}` in the build log, and stop only for a fork no row covers.
- An applied fallback that raises the bump follows the row's bump effect, and the downgrade block still applies.
- A criterion marked `CI` in `## Criteria` counts as validated only after the step's first CI run.
- A missing table counts as an empty one.
- The initiative skill's Chart step and the orchestrator skill's Discovery Start Actions name the tables with one line each.
- The skill text total stays at or under 1720 lines.

## Acceptance Criteria
- [ ] AC-1: a step applies a row
  - Given I-C Run
  - When a test reads it
  - Then it applies a matching row, logs the decision line, and stops only for an uncovered fork
- [ ] AC-2: CI-only criteria wait for CI
  - Given I-C Run
  - When a test reads it
  - Then a CI criterion counts as validated only after the first CI run
- [ ] AC-3: both skills point to the rules
  - Given the initiative and orchestrator skills
  - When a test reads them
  - Then each names `## Decisions` and the skill text total is at most 1720 lines

## Dependencies
- REQ-001
