# Requirement: REQ-005 - living docs and skill count

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I find the three parts of an initiative explained and the new skill counted, so that I know which session does what.

## Functional Requirements
- `ravintio-zero/standards/roadmap-standards.md` and `ravintio-zero/project-operations.md` hold the table of the three parts (skill, driver, orchestrator) and the run sequence.
- `ravintio-zero/component.yml`, `docs/architecture-overview.md`, and `ravintio-zero/pipeline-reference.md` count 16 skills and name `ravintio-initiative`. `component.yml` lists the watch script and the ack split in its responsibilities.
- `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-skills-catalogue.md` gains a catalogue row.
- Tests that pin the skill count change from 15 to 16, and the skill text budget in test 0000031 req-003 rises to fit the new skill.
- The Pack Index of the orchestrator keeps its links valid.

## Acceptance Criteria
- [ ] AC-1: the docs hold the three parts
  - Given the two documents
  - When a test reads them
  - Then each holds the three-part table and the seven-step run sequence
- [ ] AC-2: the counts agree
  - Given the component manifest, the overview, and the pipeline reference
  - When a test reads them
  - Then each counts 16 skills and names `ravintio-initiative`
- [ ] AC-3: the older suites pass
  - Given the changed counts
  - When the full test runner runs
  - Then every suite passes

## Dependencies
- REQ-004
