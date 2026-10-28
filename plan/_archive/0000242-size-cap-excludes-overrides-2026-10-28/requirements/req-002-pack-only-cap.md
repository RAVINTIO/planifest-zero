---
title: "Requirement: REQ-002 - The combined cap is the pack-only figure"
summary: "The combined cap is the pack-only figure"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The combined cap is the pack-only figure

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Source:** US-002
**Priority:** must-have

## User Story

As a pack maintainer, I want the cap set to the pack-only figure, so that a pack change that grows the boot file or `SKILL.md` still fails the test.

## Functional Requirements
- The combined cap is 32,800 bytes. The pack-only sum on 2026-10-28 is 32,697 bytes.
- The comment above the cap states the figure, the margin, and that overrides are excluded.

## Acceptance Criteria
- [ ] AC-1: current pack passes
  - Given the current `SKILL.md` and the pack-only `CLAUDE.md`
  - When the test compares their sum with the cap
  - Then the sum is at most 32,800 bytes
- [ ] AC-2: pack growth fails
  - Given the pack-only measure plus 104 extra bytes
  - When the test compares the sum with the cap
  - Then the comparison fails

## Dependencies
- REQ-001
