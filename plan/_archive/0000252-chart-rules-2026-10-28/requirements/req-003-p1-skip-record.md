---
title: "Requirement: REQ-003 - P1 skip record"
summary: "Chart records whether each step may skip P1, and a step with no yes row stops when it would skip."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - P1 skip record

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000252-chart-rules
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see chart record a `yes` or `no` and a reason for P1 per step, and a step with no `yes` row stop when it would skip P1, so that no step skips a phase alone.

## Functional Requirements
- `initiative.template.md` has a `## P1 skips` section between `## Criteria` and `## Steps`. It holds one row per step with the step, `yes` or `no`, and a reason.
- The `## Steps` table keeps its columns.
- The I-A Chart section of `roadmap-standards.md` says chart may mark `yes` only for a chore with exact tasks in `initiative.md`, or a change with no code. The human's confirmation of the chart approves the column.
- I-C Run says a step with no `yes` row that would skip P1 prints `I-C Run: Blocked:` and stops. A missing table counts as an empty one.
- When a step skips P1 with a `yes` row, the build log holds a `Skipped: P1` line that names the chart row.
- The Phase Skip Protocol reference states the same stop for a step session.
- `ravintio-initiative/SKILL.md` names the `## P1 skips` table in its Chart section.

## Acceptance Criteria
- [ ] AC-1: the template has the P1 skip field
  - Given `initiative.template.md`
  - When the test reads it
  - Then it finds `## P1 skips` between `## Criteria` and `## Steps`, with a reason column, and the `## Steps` header is unchanged
- [ ] AC-2: the standard states which steps are skippable and the stop
  - Given `roadmap-standards.md`
  - When the test reads the I-A Chart and I-C Run sections
  - Then it finds the chore-with-exact-tasks rule, the no-code rule, and the `I-C Run: Blocked` stop for a step with no `yes` row
- [ ] AC-3: the build log names the chart row
  - Given the I-C Run section and the Phase Skip Protocol reference
  - When the test reads them
  - Then it finds the `Skipped: P1` line that names the chart row

## Dependencies
- none
