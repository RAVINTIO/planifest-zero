---
title: "Requirement: req-002 - archive folder"
summary: "I-E Delivery archives to an -initiative- folder, and the driver reads both folder forms."
status: "draft"
version: "0.1.0"
---
# Requirement: req-002 - archive folder

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000192-rename-runner-lock-and-archive
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find a delivered initiative at `plan/_archive/{id}-{slug}-initiative-{date}/`, so that the archive name says what it holds.

## Functional Requirements
- I-E Delivery in `roadmap-standards.md` moves `plan/current-initiative/` to `plan/_archive/{id}-{slug}-initiative-{date}/`.
- The driver treats an initiative as delivered when `plan/current-initiative/initiative.md` is gone and `plan/_archive/` holds a folder that starts with `{id}-{slug}-initiative-` or `{id}-{slug}-roadmap-`.
- Existing archive folders keep their names.

## Acceptance Criteria
- [ ] AC-1: Delivery names the new folder
  - Given `roadmap-standards.md`
  - When a reader opens the I-E Delivery stage
  - Then it names `plan/_archive/{id}-{slug}-initiative-{date}/`
- [ ] AC-2: New folder form counts as delivered
  - Given a stub initiative archived to `plan/_archive/{id}-{slug}-initiative-{date}/`
  - When the driver runs the last step
  - Then it exits zero and reports the initiative delivered
- [ ] AC-3: Old folder form still counts as delivered
  - Given a stub initiative archived to the old `-roadmap-` archive folder form
  - When the driver runs the last step
  - Then it exits zero and reports the initiative delivered

## Dependencies
- None
