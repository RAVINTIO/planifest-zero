# Requirement: REQ-006 - driver final report

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I get a final report that names each step the driver ran, so that I see the result of the whole initiative.

## Functional Requirements
- The driver keeps a list of the steps it ran. At delivery it prints one `I-E Delivery:` line per step, then the final line.
- `ravintio-zero/scripts/initiative-run.mjs` header comments describe the report.

## Acceptance Criteria
- [ ] AC-1: the final report names each step
  - Given a stub that merges steps 1 and 2 and then archives the initiative
  - When the driver runs to delivery
  - Then its output holds a `step 1` line and a `step 2` line before the last `I-E Delivery:` line

## Dependencies
- REQ-001
