---
title: "Requirement: REQ-003 - Pack Index names a trigger for every reference file"
summary: "Pack Index names a trigger for every reference file"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Pack Index names a trigger for every reference file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Source:** US-003
**Priority:** must-have

## User Story

As an agent, I want one rule for template reads and one row per reference file, so that the index names each trigger.

## Functional Requirements
- The template rows become one rule: before you write an artifact, read `ravintio-zero/templates/{artifact}.template.md`.
- Rows that do not follow that pattern stay.
- Each file in `references/` has one row that names the moment to read it.
- `SKILL.md` keeps the headings Hard Limits, Phases and Response Prefixes, Resume Detection, and Pack Index (JIT Loading).

## Acceptance Criteria
- [ ] AC-1: one row per file
  - Given the files in `references/`
  - When the test reads the Pack Index
  - Then each file has a row with a trigger
- [ ] AC-2: template rule
  - Given the Pack Index
  - When the test reads it
  - Then the template rule appears and no template row repeats it
- [ ] AC-3: headings
  - Given `SKILL.md`
  - When the test counts headings
  - Then the four kept headings each appear once

## Dependencies
- REQ-001
