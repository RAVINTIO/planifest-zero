---
title: "Requirement: REQ-003 - Repo skills for task rules"
summary: "GUTD and branch cleanup become repo capability skills and three overrides retarget."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Repo skills for task rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Source:** US-003
**Priority:** must-have

## User Story

As a human, I run `/gutd`, so that the sync rule loads only on demand.

## Functional Requirements
- `ravintio-overrides/capability-skills/gutd/SKILL.md` holds the GUTD rule. Its description also matches the bare token `GUTD`.
- `ravintio-overrides/capability-skills/delete-redundant-branches/SKILL.md` holds the branch cleanup rule.
- Overrides custom-003 and custom-005 are deleted.
- Overrides custom-002, custom-004, and custom-006 gain a `target:` of `ravintio-orchestrator`, `ravintio-ship`, and `ravintio-refresh-setup`.
- Every current rule stays in force.

## Acceptance Criteria
- [ ] AC-1: gutd installs
  - Given the repo overrides
  - When setup runs
  - Then `.claude/skills/gutd/SKILL.md` exists with its description intact and the boot file lacks the GUTD rule
- [ ] AC-2: rules survive
  - Given the retargeted overrides
  - When setup runs
  - Then each former rule appears in its skill, and the boot file keeps only custom-001

## Dependencies
- REQ-002
