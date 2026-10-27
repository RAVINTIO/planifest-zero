# Requirement: REQ-002 - prefix line in the phase skills

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I see a valid phase or stage prefix on every reply in an active run, including after compaction and in a supervising session, so that I know which phase a reply belongs to.

## Functional Requirements
- The opening lines of `ravintio-plan`, `ravintio-implement`, `ravintio-validate-and-accept`, and `ravintio-ship` each hold one line that states the skill's prefix and the status form. The lines read `P1 Plan:`, `P2 Implement:`, `P3 Validate:`, and `P4 Ship:`.
- The line sits before the first section heading after the title block, so a truncated load still shows it.

## Acceptance Criteria
- [ ] AC-1: each phase skill states its prefix
  - Given the four phase skills
  - When a test reads the first 15 lines after the frontmatter of each
  - Then each holds its own prefix and the status form

## Dependencies
- None
