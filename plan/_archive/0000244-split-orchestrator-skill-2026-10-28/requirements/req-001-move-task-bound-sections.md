---
title: "Requirement: REQ-001 - Task-bound sections live in reference files"
summary: "Task-bound sections live in reference files"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Task-bound sections live in reference files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want the six task-bound sections in reference files, so that a session reads them only when it needs them.

## Functional Requirements
- How You Coach, Discovery Start Actions, Discovery Gate Checklist, Design Confirmation, Phase Invocation, and Exception Stops move into new `references/orchestrator-*.md` files, line for line.
- `SKILL.md` keeps a short P0 intro and a Phase Invocation pointer in the Pack Index.
- The orchestrator `SKILL.md` is 9,000 bytes or fewer.

## Acceptance Criteria
- [ ] AC-1: size
  - Given the orchestrator `SKILL.md`
  - When the size test measures it
  - Then it is 9,000 bytes or fewer
- [ ] AC-2: heading placement
  - Given each moved section heading
  - When the test searches `SKILL.md` and `references/`
  - Then the heading appears in exactly one reference file and not in `SKILL.md`
- [ ] AC-3: nothing lost
  - Given the base fixture
  - When the test compares each non-blank, non-heading line
  - Then every line is in `SKILL.md`, a reference file, or `roadmap-standards.md`

## Dependencies
- None
