---
title: "Requirement: REQ-001 - Test impact scan"
summary: "The plan skill scans the tests for counts, budgets, caps and ids and the execution plan lists each match."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Test impact scan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000246-plan-checks-count-and-cap-tests
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I read the tests that hold counts, budgets, caps and ids in the execution plan, so that a run ends with no rework loop for those causes.

## Functional Requirements
- `ravintio-plan/SKILL.md` has a `## Test impact scan` section of 15 lines or fewer.
- The section names four causes: the skill count, the skill-text budget, a size cap on an edited skill, and the id of a pulled-in backlog entry.
- The section tells the plan agent to grep `ravintio-zero/tests/` for each cause and to record "none found" when a grep matches nothing.
- `execution-plan.template.md` has a `## Test impact` section with a table of cause, test and unit.
- A test fails when either file loses its section.

## Acceptance Criteria
- [ ] AC-1: skill carries the scan
  - Given the plan skill
  - When the test reads it
  - Then it finds the section, the four causes and the "none found" rule
- [ ] AC-2: template carries the section
  - Given the execution plan template
  - When the test reads it
  - Then it finds the `## Test impact` heading and the table columns
- [ ] AC-3: scan stays small
  - Given the plan skill
  - When the test counts the section lines
  - Then the section holds 15 lines or fewer

## Dependencies
- none
