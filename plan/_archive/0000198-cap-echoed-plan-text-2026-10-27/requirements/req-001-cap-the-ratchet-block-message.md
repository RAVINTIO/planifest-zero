---
title: "Requirement: REQ-001 - cap the ratchet block message"
summary: "ratchet-check prints at most 200 characters of each removed line and marks the cut."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - cap the ratchet block message

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Source:** US-001
**Priority:** must-have

## User Story

As an agent that a ratchet block stops, I see at most 200 characters of each removed line and a cut marker, so that a long or hostile line never floods my context.

## Functional Requirements
- `ratchet-check.mjs` prints each `removed:` line cut to 200 characters. If it cuts a line, it appends the existing marker ` …[truncated]`.
- A removed line of 200 characters or fewer prints unchanged.
- The cap counts code points, so it never splits a surrogate pair.
- The hook blocks and passes the same writes and exits with the same codes as before. Only the echoed text changes.

## Acceptance Criteria
- [ ] AC-1: long removed line
  - Given a loop is active and an edit removes a guarded line of 1000 characters
  - When the hook runs
  - Then it exits 2 and the `removed:` line holds the first 200 characters followed by the cut marker
- [ ] AC-2: short removed line
  - Given a loop is active and an edit removes a guarded line of 200 characters or fewer
  - When the hook runs
  - Then the `removed:` line holds the whole line with no cut marker
- [ ] AC-3: existing behaviour
  - Given the existing ratchet suites
  - When they run against the changed hook
  - Then every test passes

## Dependencies
- None
