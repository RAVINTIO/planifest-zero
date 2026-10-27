# Requirement: REQ-001 - retrospective skill and record template

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Source:** US-001, US-002, US-003
**Priority:** must-have

## User Story

As the human on the loop, I get one blameless retrospective for every shipped run and every delivered initiative, with at least one thing to keep and one to change, so that the next run does not repeat the same friction.

## Functional Requirements
- `ravintio-zero/skills/ravintio-retrospective/SKILL.md` defines the skill with frontmatter `name` and `description`. It stays under 120 lines.
- The skill has a run mode and an initiative mode. The run mode runs at ship after the build report. The initiative mode runs at I-E Delivery after the archive and before the PR to `main`.
- The skill states the blameless rules. It names no person or agent as a cause, and it copies no credential from a log.
- The run mode reads the build log, the `Rework:` lines, the `Blocked:` and `Resolved:` lines, and the postmortems the run wrote.
- The initiative mode answers four questions: how the charted steps, bumps, and versions compare with what shipped, which friction repeated across steps, what happened at each stop and how long each step took, and which initiative tooling gaps showed up.
- Each record names at least one thing to keep and one to change.
- Each change becomes a backlog entry or a repo instruction. The filed item names the source retrospective, and the record links to it.
- The skill writes the record to `plan/retrospectives/` and creates the folder if it is missing. It writes nothing under `plan/current/`.
- `ravintio-zero/templates/retrospective.template.md` holds the record format.

## Acceptance Criteria
- [ ] AC-1: the skill exists and is short
  - Given the pack source
  - When a test reads `ravintio-zero/skills/ravintio-retrospective/SKILL.md`
  - Then the file has `name: ravintio-retrospective` frontmatter and fewer than 120 lines
- [ ] AC-2: the skill states the method
  - Given the skill file
  - When a test reads its text
  - Then the text names both modes, the blameless rule, the four initiative questions, the keep and change requirement, and the filing of each change with its source retrospective
- [ ] AC-3: records live outside the archive
  - Given the skill and the template
  - When a test reads them
  - Then the skill writes to `plan/retrospectives/`, never under `plan/current/`, and the template has keep, change, and actions sections

## Dependencies
- None
