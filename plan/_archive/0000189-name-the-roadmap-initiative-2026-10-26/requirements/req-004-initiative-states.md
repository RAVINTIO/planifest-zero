---
title: "Requirement: req-004 - initiative states"
summary: "The initiative template status takes the five lifecycle states."
status: "draft"
version: "0.1.0"
---
# Requirement: req-004 - initiative states

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I see an initiative's state as proposed, charted, active, delivered, or blocked, so that its status matches the lifecycle.

## Functional Requirements
- `ravintio-zero/templates/initiative.template.md` has status `proposed | charted | active | delivered | blocked`.
- `roadmap-standards.md` states which stage sets each state:
  - Drafting sets proposed.
  - I-A Chart sets charted.
  - I-B Activate sets active.
  - I-E Delivery sets delivered.
  - Any exception stop sets blocked.
- The driver still requires status `active` before it runs a step.

## Acceptance Criteria
- [ ] AC-1: Template lists the five states
  - Given `initiative.template.md`
  - When a test reads its status field
  - Then the field reads `proposed | charted | active | delivered | blocked`
- [ ] AC-2: Standard maps stages to states
  - Given `roadmap-standards.md`
  - When a test searches for each state
  - Then each of the five states appears with the stage that sets it

## Dependencies
- REQ-001 defines the states in the glossary.
