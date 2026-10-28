---
title: "Requirement: REQ-002 - Commit id reservations at once"
summary: "reserve-id.mjs gains a --commit flag that commits the counter alone, and three skills call it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Commit id reservations at once

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find each id reservation in a commit as soon as it is made, so that a session on another branch never reuses the id.

## Functional Requirements
- `reserve-id.mjs --commit` commits the counter file after it writes the counter, with the message `chore: reserve ids {first} to {last}`. A single id reads `chore: reserve id {id}`.
- The commit holds the counter file alone, even when other paths are staged.
- If the commit fails, the script prints one line to stderr and exits 1. The counter keeps the new value, so no id is reused.
- The initiative, retrospective, and postmortem skills tell the agent to reserve with `--commit`. The entry itself stays uncommitted where a skill says so.

## Acceptance Criteria
- [ ] AC-1: counter change in its own commit
  - Given a temp repo with a tracked counter and another staged file
  - When the test runs `reserve-id.mjs --commit`
  - Then a new commit holds the counter file alone and the staged file stays staged
- [ ] AC-2: failure leaves the counter
  - Given a folder that is not a git repository
  - When the test runs `reserve-id.mjs --commit`
  - Then the script exits 1 with one stderr line and the counter holds the new value
- [ ] AC-3: three skills carry the rule
  - Given the initiative, retrospective, and postmortem skills
  - When the test reads them
  - Then each names `reserve-id.mjs --commit`

## Dependencies
- none
