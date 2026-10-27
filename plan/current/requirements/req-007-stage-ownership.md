# Requirement: REQ-007 - stage ownership

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I see each initiative stage owned by one skill, so that no two sessions run the same stage.

## Functional Requirements
- `roadmap-standards.md` assigns I-A, I-B, and I-E to the initiative skill and I-C and I-D to the orchestrator and ship skills.
- The orchestrator skill keeps I-C Run and holds no I-A, I-B, or I-E procedure.

## Acceptance Criteria
- [ ] AC-1: each stage has one owner
  - Given the roadmap standards and the orchestrator skill
  - When a test reads the stage table and the orchestrator text
  - Then I-A, I-B, and I-E name the initiative skill, I-C and I-D name the orchestrator and ship skills, and the orchestrator holds no I-A, I-B, or I-E procedure

## Dependencies
- REQ-004
