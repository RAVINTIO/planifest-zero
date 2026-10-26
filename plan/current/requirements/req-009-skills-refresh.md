---
title: "Requirement: req-009 - skills refresh"
summary: "The installed skills match the pack skills after the run."
status: "draft"
version: "0.1.0"
---
# Requirement: req-009 - skills refresh

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-008 (added at the story map pass)
**Priority:** must-have

## User Story

As a maintainer, I find `.claude/skills/` matching `ravintio-zero/skills/` after the run, so that each session loads the renamed skills.

## Functional Requirements
- After P2, the run runs `setup.sh` with the flags in `plan/state/claude-code.md`. The human pre-approved this at P0.
- After setup, every skill file under `ravintio-zero/skills/` matches its copy under `.claude/skills/`.

## Acceptance Criteria
- [ ] AC-1: Copies match after setup
  - Given the pack source after P2
  - When the run compares `ravintio-zero/skills/` with `.claude/skills/`
  - Then every skill file matches, and P3 records the comparison as evidence

## Dependencies
- REQ-001 to REQ-004 change the skill files first.
