---
title: "Requirement: req-011 - chart-time-schema-approval"
summary: "R-A Chart predicts each step's schema change for the human to approve by name, so a matching additive change does not stop the step."
status: "draft"
version: "0.1.0"
---
# Requirement: req-011 - chart-time-schema-approval

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-002, US-004
**Priority:** must-have

## User Story

As a human on the loop, I approve each step's predicted schema change at R-A Chart, so that an additive change does not stop the chain while I'm away.

Added at P3 by a human-confirmed design change, after the live acceptance run stopped at migration M-003 in step 1.

## Functional Requirements
- Chart predicts each step's schema change and lists it in a `## Schema changes` table in `roadmap.md`.
  - Chart reads each step's backlog entries and the data contracts of the components they touch.
  - The human approves, edits, or strikes each row. The chart confirmation approves the rows left.
  - Chart asks one opt-in fallback question that pre-approves additive changes it didn't predict. The default is `stop`.
  - A listed destructive change still stops at the step, under Hard Limit 4.
- A step that proposes a schema change still writes the migration proposal, in P1 or P2.
  - A proposal that matches a chart-approved row is marked `approved (roadmap chart)`, and the step carries on. A match needs the same step, component, field names, and types, and Kind `additive`.
  - An unmatched additive proposal is marked `approved (roadmap chart fallback)` only when the fallback is `pre-approved`. Otherwise the step takes the normal schema-change exception stop.
  - A destructive change always stops, under Hard Limit 4.

## Acceptance Criteria
- [ ] (a) The roadmap standard states that Chart surveys each step's data contracts into a `## Schema changes` table, that the human approves, edits, or strikes each row, and that the chart confirmation approves the rows left.
- [ ] (b) The roadmap standard states that Chart asks an opt-in fallback question for unpredicted additive changes with `stop` as the default, and the template holds the table and the fallback field.
- [ ] (c) The roadmap standard states that a step still writes each migration proposal, marks a proposal that matches a chart-approved additive row `approved (roadmap chart)` and carries on, takes the normal stop for anything else unless the fallback is `pre-approved`, and always stops on a destructive change. The implement skill's schema rule points to the standard.

## Dependencies
- REQ-002 supplies R-A Chart and the human's confirmation.
- REQ-004 supplies R-C Run, where the step writes its proposal.
- ADR-006, amended 2026-10-24, records the decision.
- Files in reach:
  - `planifest-zero/standards/roadmap-standards.md`
  - `planifest-zero/templates/roadmap-entry.template.md`
  - `planifest-zero/skills/planifest-implement/SKILL.md` (one pointer clause)
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (one pointer clause in the exception table)
  - `planifest-zero/tests/test-0000043-req-011-chart-time-schema-approval.sh` (new)
