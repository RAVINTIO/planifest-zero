---
title: "Requirement: req-003 - initiative prefixes"
summary: "Initiative stage messages use I-A to I-E."
status: "draft"
version: "0.1.0"
---
# Requirement: req-003 - initiative prefixes

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see `I-A Chart:` to `I-E Delivery:` on initiative stage messages, so that the prefix names the initiative.

## Functional Requirements
- The stage prefixes are `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, and `I-E Delivery:`.
- The orchestrator skill, `roadmap-standards.md`, the ship skill, and the driver stop lines use the new prefixes.
- The orchestrator skill still states that stage letters are not phase numbers. The pipeline has five phases, P0 to P4.
- The prefix test checks for the `I-` prefixes and fails on an `R-A` to `R-E` prefix in the pack source.

## Acceptance Criteria
- [ ] AC-1: Skills and standard list the new prefixes
  - Given the orchestrator skill and `roadmap-standards.md`
  - When the prefix test reads their stage tables
  - Then each lists the five `I-` prefixes and no `R-` prefix
- [ ] AC-2: Driver stops with the new prefix
  - Given an initiative file whose status is not `active`
  - When the driver starts
  - Then it exits non-zero with a line that starts `I-C Run: Blocked:`

## Dependencies
- REQ-002 renames the driver that prints these lines.
