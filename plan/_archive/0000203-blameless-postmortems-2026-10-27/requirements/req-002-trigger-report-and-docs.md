# Requirement: REQ-002 - orchestrator trigger, build report line, and docs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As the human on the loop, I see the orchestrator run the skill after a `Resolved:` line and the build report list the run's postmortems, so that I can find them.

## Functional Requirements
- `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` adds one rule to Exception Stops. After the `Resolved:` line is committed, the orchestrator runs `ravintio-postmortem` for that stop, before ship.
- `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-skills-catalogue.md` adds a row for `ravintio-postmortem` with its trigger.
- `ravintio-zero/skills/ravintio-ship/SKILL.md` makes the build report list each record the run wrote to `plan/postmortems/`, or state `none`.
- `ravintio-zero/component.yml`, `ravintio-zero/pipeline-reference.md`, and `docs/architecture-overview.md` name the skill and update the skill count to 14.

## Acceptance Criteria
- [ ] AC-1: the orchestrator runs the skill after a Resolved line
  - Given the orchestrator skill and the catalogue
  - When a test reads them
  - Then the skill names `ravintio-postmortem` after the `Resolved:` line before ship, and the catalogue has a row for it
- [ ] AC-2: the build report lists postmortems
  - Given the ship skill
  - When a test reads its build report step
  - Then the step lists the run's records from `plan/postmortems/` or states `none`
- [ ] AC-3: the docs name the skill
  - Given the three living docs
  - When a test reads them
  - Then each names `ravintio-postmortem` and the count of 14 skills

## Dependencies
- REQ-001
