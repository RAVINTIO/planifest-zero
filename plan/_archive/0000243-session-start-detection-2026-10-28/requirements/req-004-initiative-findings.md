---
title: "Requirement: REQ-004 - Step and initiative sessions get the same findings"
summary: "Step and initiative sessions get the same findings"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Step and initiative sessions get the same findings

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-004
**Priority:** must-have

## User Story

As a person running an initiative, I want the initiative skill to use the same findings, so that driver lock and position checks are tested too.

## Functional Requirements
- When an initiative is active, the script also prints the driver lock state and the initiative position.
- In a step session (`RAVINTIO_INITIATIVE_STEP=1`) and in an initiative session the hook injects the same findings, each with its own skill name.
- Session Start in the initiative skill reads those findings.

## Acceptance Criteria
- [ ] AC-1: same findings
  - Given an active initiative fixture
  - When the hook runs with and without `RAVINTIO_INITIATIVE_STEP=1`
  - Then both outputs hold the same finding lines
- [ ] AC-2: skill name
  - Given the same fixture
  - When the hook runs in each mode
  - Then the step output names the orchestrator and the other names the initiative skill

## Dependencies
- REQ-003
