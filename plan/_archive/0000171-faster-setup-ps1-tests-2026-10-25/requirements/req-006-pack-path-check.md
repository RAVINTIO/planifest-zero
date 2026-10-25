---
title: "Requirement: REQ-006 - pack-path-check"
summary: "A test fails when a skill names a pack file by anything but an existing full ravintio-zero path."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - pack-path-check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** Requirement change 2026-10-25 (human request during R-D Advance)
**Priority:** must-have

## User Story

As a pack maintainer, I get a failing test when a skill names a pack file loosely or names one that does not exist, so that path drift never ships.

## Functional Requirements
- A Bash suite scans `ravintio-zero/skills/**/*.md` for mentions of a file that exists in `ravintio-zero/templates/`, `ravintio-zero/standards/`, or `ravintio-zero/schemas/`.
- A mention passes only when it is the full `ravintio-zero/...` path.
- Every full `ravintio-zero/templates/`, `ravintio-zero/standards/`, or `ravintio-zero/schemas/` path in a skill must exist.
- Each failure names the skill file, the line number, and the path text.
- The suite runs in the Bash suites in CI on Linux, so one run covers every platform.

## Acceptance Criteria
- [ ] AC-1: A short path fails
  - Given a fixture skill that names `templates/requirement.template.md`
  - When the check runs on the fixture
  - Then it fails and names the file, line, and path
- [ ] AC-2: A missing full path fails
  - Given a fixture skill that names `ravintio-zero/templates/no-such.template.md`
  - When the check runs on the fixture
  - Then it fails and names the path
- [ ] AC-3: The pack passes
  - Given the real skill sources
  - When the check runs
  - Then it passes

## Dependencies
- None
