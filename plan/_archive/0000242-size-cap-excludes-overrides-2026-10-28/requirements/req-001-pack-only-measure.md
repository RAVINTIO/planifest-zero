---
title: "Requirement: REQ-001 - The size cap measure excludes the override block"
summary: "The size cap measure excludes the override block"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - The size cap measure excludes the override block

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want the size cap to measure the boot file without the override block, so that adding an override never changes the result.

## Functional Requirements
- The test counts the bytes of `CLAUDE.md` with every line from the `ravintio-overrides:instructions:start` marker to the `end` marker removed.
- A `CLAUDE.md` with no markers is counted whole.

## Acceptance Criteria
- [ ] AC-1: override added
  - Given a copy of `CLAUDE.md` with a 5,000 byte override block appended between the markers
  - When the test measures the pack-only bytes of the copy and of the original
  - Then both measures are equal
- [ ] AC-2: no markers
  - Given a file with no override markers
  - When the test measures its pack-only bytes
  - Then the measure equals the file size

## Dependencies
- None
