---
title: "Requirement: REQ-003 - gherkin-consistency-rule"
summary: "consistency-check.mjs flags a criterion that lacks a Given, When, or Then step or holds them out of order."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - gherkin-consistency-rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Source:** US-003 (backlog 0000165)
**Priority:** must-have

## User Story

As a maintainer, I get a consistency check that flags a malformed Gherkin criterion, so that the format holds without review.

## Functional Requirements
- Today `ravintio-zero/scripts/consistency-check.mjs` counts criteria and checks nothing about their content.
- For each requirement file, the script reads each criterion. A criterion is a checkbox line in `## Acceptance Criteria`, with the indented lines under it.
- The script flags a criterion that has no `Given`, no `When`, or no `Then` step.
- The script flags a criterion whose first steps are out of order. The order is `Given`, then `When`, then `Then`. `And` and `But` may follow any step.
- Each finding names the requirement file and the criterion's `AC-n`. If the criterion has no `AC-n`, the finding names the line number.
- The maximum of three criteria per requirement is unchanged. The count stays on checkbox lines.
- The script header comment documents the new checks.
- The checks read `plan/current/` only. Archived runs keep their old format.

## Acceptance Criteria
- [ ] AC-1: Missing step flagged
  - Given a fixture requirement whose criterion has `Given` and `Then` lines but no `When`
  - When a test runs `node consistency-check.mjs` on the fixture directory
  - Then the exit code is 1 and stdout names the file and the criterion's `AC-n`
- [ ] AC-2: Wrong order flagged
  - Given a fixture requirement whose criterion lists `Then` before `When`
  - When a test runs `node consistency-check.mjs` on the fixture directory
  - Then the exit code is 1 and stdout names the file and the criterion's `AC-n`
- [ ] AC-3: Valid criteria pass
  - Given a clean fixture whose criteria use `Given`, `When`, `Then`, and `And`/`But` continuation, with three or fewer checkbox lines
  - When a test runs `node consistency-check.mjs` on the fixture directory
  - Then the exit code is 0, and a header comment in the script names the Gherkin check

## Dependencies
- REQ-002 defines the format this rule checks.
- REQ-004 adds the story map rules to the same script.
- REQ-005 moves the 0000016 consistency fixtures to the Gherkin format, so they stay valid under this rule.
