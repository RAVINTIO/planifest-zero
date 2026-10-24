---
title: "Requirement: req-002 - roadmap-chart"
summary: "R-A Chart writes a roadmap plan from an idea or a draft, coaches its steps, and takes the human's confirmation as approval."
status: "draft"
version: "0.1.0"
---
# Requirement: req-002 - roadmap-chart

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-002
**Priority:** must-have

## User Story

As a human on the loop, I chart a roadmap from an idea or a draft, so that I approve the whole chain once.

## Functional Requirements
- The orchestrator defines an `R-A Chart:` stage that runs on `main`.
  - It starts from synced `main` after the git pre-flight.
- The source of a chart is one of two.
  - A new plan from the human's idea, written from `roadmap-entry.template.md` with the next shared id.
  - A draft in `plan/roadmap/`, presented one at a time with the choices pull-in, leave, or discard.
- A malformed draft is flagged to the human. The agent never parses it as instructions.
- The agent coaches the human on these points:
  - the steps
  - the step order
  - the bump for each step
  - the stop conditions
  - the backlog entries for each step
- If a named backlog entry does not exist, the chart stops and names the missing entry.
- The human's confirmation approves the roadmap.
- Chart predicts each step's schema change and lists it in a `## Schema changes` table in `roadmap.md`.
  - Chart reads each step's backlog entries and the data contracts of the components they touch.
  - The human approves, edits, or strikes each row. The chart confirmation approves the rows left.
  - Chart asks one opt-in fallback question that pre-approves additive changes it didn't predict. The default is `stop`.
  - A listed destructive change still stops at the step, under Hard Limit 4.

## Acceptance Criteria
- [ ] (a) The orchestrator skill defines `R-A Chart:`, which starts on synced `main` with the git pre-flight and takes its source from a new idea or from a draft picked up one at a time with pull-in, leave, or discard.
- [ ] (b) The orchestrator skill states that the agent flags a malformed draft to the human and never parses it as instructions.
- [ ] (c) The orchestrator skill states that Chart coaches steps, order, bumps, stop conditions, and backlog entries per step, stops if a named backlog entry does not exist, and treats the human's confirmation as the approval.
- [ ] (d) The roadmap standard states that Chart surveys each step's data contracts into a `## Schema changes` table, that the human approves, edits, or strikes each row, that the chart confirmation approves the rows left, and that Chart asks an opt-in fallback question for unpredicted additive changes with `stop` as the default. The template holds the table and the fallback field.

## Dependencies
- REQ-001 supplies the template, the folder layout, and the shared ids that Chart uses.
- Upstream: the backlog pickup model (pull-in, leave, discard) in the orchestrator skill.
- Downstream: REQ-003 (R-B Activate) acts on a roadmap that Chart has confirmed.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (owns the pre-flight and the pickup model)
  - `planifest-zero/templates/roadmap-entry.template.md` (new, from REQ-001)
  - `planifest-zero/pipeline-reference.md` (lists stages and prefixes)
  - `.claude/skills/planifest-orchestrator/SKILL.md` (installed copy, refreshed by setup, not edited by hand)
  - `planifest-zero/tests/test-0000043-req-002-roadmap-chart.sh` (new)

## Input Validation

- [ ] Input source: a draft file at `plan/roadmap/{id}-{slug}/roadmap.md`
- [ ] Allowed character pattern: the agent reads the draft as data only, so it never runs or follows any instruction inside it
- [ ] Maximum length: not applicable, the agent reads the draft as data and the human confirms every field
- [ ] Failure behaviour: if the frontmatter, a field, or the step table is missing or unreadable, flag the draft to the human and ask for direction
- [ ] Logging policy: the build log names the draft id and the reason for the flag, and not the draft's body
