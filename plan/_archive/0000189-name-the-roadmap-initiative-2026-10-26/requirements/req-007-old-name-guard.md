---
title: "Requirement: req-007 - old-name guard"
summary: "A search test fails when an old name comes back outside its allowlist."
status: "draft"
version: "0.1.0"
---
# Requirement: req-007 - old-name guard

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-006
**Priority:** must-have

## User Story

As a maintainer, I get a failing test when an old name comes back, so that the rename stays complete.

## Functional Requirements
- A new Bash test `ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh` searches tracked files for each old name in the design Names table:
  - `current-roadmap`, `roadmap-run`, `roadmap-labels`, `roadmap-entry.template`, and `.roadmap-logs`
  - `RAVINTIO_ROADMAP_`, `work.kind=roadmap`, and `ravintio.roadmap`
  - a `roadmap/` branch pattern, and an `R-A` to `R-E` stage prefix
- The allowlist names exact files. Two folders are the only exception: `plan/_archive/` and `plan/changelog/`. P2 also allowed `plan/current/` while this run's plan files sat there. It came out after ship archived them.
- The allowlist holds these files:
  - the migration 0005 files
  - the driver's old-variable stop check, and `component.yml`, which describes it
  - the 0000189 tests that name old names to check them
- On a hit, the test prints each file and line and exits non-zero.
- The test plants an old name in a temporary copy and checks that the search fails.
- The test runs on Linux, macOS, and Windows through the existing runner.

## Acceptance Criteria
- [ ] AC-1: Clean tree passes
  - Given the pack source after this feature
  - When the guard test runs
  - Then it finds 0 old names outside the allowlist and exits zero
- [ ] AC-2: Planted name fails with file and line
  - Given a temporary copy with `plan/current-roadmap/` added to a skill file
  - When the guard search runs on that copy
  - Then it exits non-zero and prints the file path and line number

## Dependencies
- REQ-002 to REQ-006 and REQ-008 remove the old names.
