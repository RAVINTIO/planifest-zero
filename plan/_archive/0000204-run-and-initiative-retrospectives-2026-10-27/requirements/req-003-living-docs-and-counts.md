# Requirement: REQ-003 - living docs and skill count

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the human on the loop, I find the skill in the living docs and in the skill counts, so that the docs match what the pack ships.

## Functional Requirements
- `ravintio-zero/component.yml`, `ravintio-zero/pipeline-reference.md`, and `docs/architecture-overview.md` name `ravintio-retrospective` and count 15 skills.
- Tests `0000031` req-003, `0000031` req-004, and `0000160` req-001 list the new skill, count 15 skills, and state the new skill-text line budget.

## Acceptance Criteria
- [ ] AC-1: the docs name the skill
  - Given the three docs
  - When a test reads them
  - Then each names `ravintio-retrospective`, `component.yml` says "The 15 skills", and the overview says "fifteen"
- [ ] AC-2: the count tests agree
  - Given the pack source
  - When the full suite runs
  - Then the three count tests pass with 15 skills

## Dependencies
- REQ-001
- REQ-002
