---
title: "Requirement: REQ-002 - cap the consistency finding"
summary: "consistency-check prints at most 200 characters of a story map row label and marks the cut."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - cap the consistency finding

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Source:** US-002
**Priority:** must-have

## User Story

As an agent that runs the consistency check, I see at most 200 characters of a story map row label in a finding and a cut marker, so that a long or hostile label never floods my context.

## Functional Requirements
- `consistency-check.mjs` cuts the story map row `label` to 200 characters in both findings that echo it: the empty Requirement cell finding and the missing requirement file finding.
- If it cuts a label, it appends the marker ` …[truncated]`.
- A label of 200 characters or fewer prints unchanged.
- The cap counts code points, so it never splits a surrogate pair.
- The check raises the same findings and exits with the same codes as before. Only the echoed label changes.

## Acceptance Criteria
- [ ] AC-1: long label in a finding
  - Given a story map row with a label of 1000 characters and an empty Requirement cell
  - When the check runs
  - Then it exits 1 and the finding holds the first 200 characters of the label followed by the cut marker
- [ ] AC-2: short label
  - Given a story map row with a label of 200 characters or fewer and a dangling `REQ-` reference
  - When the check runs
  - Then the finding holds the whole label with no cut marker
- [ ] AC-3: existing behaviour
  - Given the existing consistency suites
  - When they run against the changed check
  - Then every test passes

## Dependencies
- None
