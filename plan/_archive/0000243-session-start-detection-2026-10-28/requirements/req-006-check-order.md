---
title: "Requirement: REQ-006 - Findings print in check order"
summary: "Findings print in check order"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - Findings print in check order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want the findings in a fixed order, so that the agent acts on them in the order of the checks.

## Functional Requirements
- The script prints findings in the order of the 12 checks.
- It prints `no resume signals` when it finds none.

## Acceptance Criteria
- [ ] AC-1: order
  - Given a fixture with every signal
  - When the script runs on it
  - Then the lines print in the order of the 12 checks
- [ ] AC-2: no signals
  - Given a fixture with no signal
  - When the script runs on it
  - Then it prints `no resume signals`

## Dependencies
- REQ-001
