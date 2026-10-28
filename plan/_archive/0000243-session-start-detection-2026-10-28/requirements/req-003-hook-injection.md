---
title: "Requirement: REQ-003 - The hook injects the findings or a failure line"
summary: "The hook injects the findings or a failure line"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - The hook injects the findings or a failure line

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-002
**Priority:** must-have

## User Story

As an agent starting a session, I want the findings in context before any skill loads, so that I act on a tested list.

## Functional Requirements
- `auto-trigger-orchestrator.mjs` runs the script with a 2 second timeout on the prompt where it injects the load instruction.
- It appends the script's lines to that instruction.
- If the script exits non-zero or times out, it appends `resume detection did not run` and still injects the load instruction.

## Acceptance Criteria
- [ ] AC-1: findings injected
  - Given a fixture project with one signal
  - When the hook runs
  - Then its output holds the load instruction and that signal's line
- [ ] AC-2: failure
  - Given a script that exits non-zero or runs past the timeout
  - When the hook runs
  - Then its output holds the load instruction and `resume detection did not run`

## Dependencies
- REQ-001
