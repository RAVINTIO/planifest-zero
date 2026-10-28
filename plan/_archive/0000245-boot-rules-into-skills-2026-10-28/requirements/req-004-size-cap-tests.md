---
title: "Requirement: REQ-004 - Boot file size cap"
summary: "A test caps the generated CLAUDE.md and the installed-copy test ignores override blocks."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Boot file size cap

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I see a test cap the generated `CLAUDE.md` at 6,000 bytes, so that overrides cannot regrow it.

## Functional Requirements
- A test runs setup against a temporary copy of this repo's overrides and asserts the boot file is 6,000 bytes or fewer.
- `test-0000151-req-014` ignores the appended override block when it compares installed skills with the pack.
- The pack-only cap in `test-0000151-req-011` stays as set by 0000242.

## Acceptance Criteria
- [ ] AC-1: cap holds
  - Given this repo's overrides
  - When setup generates a boot file in a temporary project
  - Then the file is 6,000 bytes or fewer
- [ ] AC-2: appended blocks ignored
  - Given an installed skill with an appended override block
  - When the installed-copy test runs
  - Then it passes

## Dependencies
- REQ-002, REQ-003
