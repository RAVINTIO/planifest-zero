---
title: "Requirement: REQ-005 - Resume Detection is a short rule with a reference"
summary: "Resume Detection is a short rule with a reference"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Resume Detection is a short rule with a reference

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-003
**Priority:** must-have

## User Story

As a pack maintainer, I want Resume Detection in `SKILL.md` cut to a short rule that points at a reference file, so that the skill has room to shrink.

## Functional Requirements
- `SKILL.md` Resume Detection tells the agent to act on each finding in order and to read that check's section in `references/orchestrator-resume-detection.md`.
- The Pack Index names the reference.
- The reference holds every line of the old section.

## Acceptance Criteria
- [ ] AC-1: size
  - Given the orchestrator `SKILL.md`
  - When the test measures the Resume Detection section
  - Then it is 400 bytes or fewer
- [ ] AC-2: reference
  - Given the Pack Index
  - When the test reads it
  - Then it names `references/orchestrator-resume-detection.md`
- [ ] AC-3: nothing lost
  - Given the old section text
  - When the test compares each of its lines
  - Then every line appears in the reference

## Dependencies
- None
