---
title: "Requirement: REQ-004 - Tests read the new locations"
summary: "Tests read the new locations"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Tests read the new locations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Source:** US-004
**Priority:** must-have

## User Story

As a pack maintainer, I want the size test and the tests that grep `SKILL.md` to read the new locations, so that the suite passes with a 9,000 byte cap.

## Functional Requirements
- `test-0000151-req-011-orchestrator-references-split.sh` asserts the 9,000 byte cap and lists the moved headings as living in reference files.
- Each test that greps a moved line reads `SKILL.md`, `references/`, and `roadmap-standards.md` together.
- Setup installs every new reference file, and each installed copy matches its source.
- No other cap is raised.

## Acceptance Criteria
- [ ] AC-1: cap
  - Given the size test
  - When it runs
  - Then it asserts 9,000 bytes for `SKILL.md`
- [ ] AC-2: install
  - Given a fresh setup run
  - When the test compares installed copies
  - Then each reference file matches its source
- [ ] AC-3: full suite
  - Given the whole test suite
  - When it runs
  - Then it passes with no other cap raised

## Dependencies
- REQ-001, REQ-002, REQ-003
