---
title: "Requirement: REQ-005 - ratchet-gherkin-guard"
summary: "ratchet-check.mjs guards Gherkin step lines in Acceptance Criteria, and the 0000016 fixtures move to Gherkin."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - ratchet-gherkin-guard

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Source:** US-005 (backlog 0000165)
**Priority:** must-have

## User Story

As a maintainer, I see the ratchet guard each Gherkin step line, so that a loop can't weaken a criterion by editing a step.

## Functional Requirements
- Today `ravintio-zero/hooks/enforcement/ratchet-check.mjs` guards only the checkbox lines in `## Acceptance Criteria`.
- The hook also guards step lines in that section. A step line is a bullet that starts with `Given`, `When`, `Then`, `And`, or `But` (ADR-004).
- While a loop is active, a write that removes a step line exits 2. The block message names the removed line.
- A write that adds a step line exits 0.
- The existing approval path through `plan/current/.ratchet-approve` applies to step lines unchanged.
- The new parsing adds no shell calls and prints no file content beyond the removed step line.
- The 0000016 consistency and ratchet fixtures move to the Gherkin format. This covers `ravintio-zero/tests/test-0000016-pipeline-governance.sh` and its copy under `tests/regression/`. The req-014 and req-018 sections still pass.

## Acceptance Criteria
- [ ] AC-1: Removing a step blocks
  - Given an active loop state and a requirement file with a `Given`, `When`, and `Then` criterion
  - When a test sends a write through the hook on stdin that removes the `When` line
  - Then the hook exits 2 and its stderr names the removed `When` line
- [ ] AC-2: Adding a step passes
  - Given the same active loop state and requirement file
  - When a test sends a write through the hook on stdin that adds an `And` line
  - Then the hook exits 0
- [ ] AC-3: Fixtures use Gherkin and pass
  - Given the 0000016 suite in the feature folder and in `tests/regression/`
  - When a test greps the req-014 and req-018 fixtures and runs both suites
  - Then the fixture criteria hold `Given`, `When`, and `Then` lines, and both suites exit 0

## Dependencies
- REQ-002 defines the step lines this hook guards.
- REQ-003 checks the same fixtures, so they must be valid Gherkin.
