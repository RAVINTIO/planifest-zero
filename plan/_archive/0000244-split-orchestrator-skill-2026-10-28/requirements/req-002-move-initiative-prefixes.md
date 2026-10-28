---
title: "Requirement: REQ-002 - Initiative stage prefixes live in the roadmap standards"
summary: "Initiative stage prefixes live in the roadmap standards"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Initiative stage prefixes live in the roadmap standards

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Source:** US-002
**Priority:** must-have

## User Story

As a pack maintainer, I want the I-A to I-E prefix block in `roadmap-standards.md`, so that only initiative work reads it.

## Functional Requirements
- The initiative stage prefix block moves to `ravintio-zero/standards/roadmap-standards.md`.
- `SKILL.md` keeps one line that says the I-A to I-E prefixes exist and where they live.

## Acceptance Criteria
- [ ] AC-1: block moved
  - Given the prefix block lines
  - When the test searches `roadmap-standards.md`
  - Then each line appears there
- [ ] AC-2: pointer kept
  - Given `SKILL.md`
  - When the test reads it
  - Then one line names `roadmap-standards.md` for the I-A to I-E prefixes

## Dependencies
- None
