# Requirement: REQ-001 - chart-time rules and template tables

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Version:** 0.28.0
**Source:** US-001, US-002, US-004
**Priority:** must-have

## User Story

As the human on the loop, I approve a pre-mortem decision table, baselines, and a criterion check at Chart, so that a step applies a pre-approved answer instead of stopping.

## Functional Requirements
- `ravintio-zero/standards/roadmap-standards.md` adds a `### Chart-time decisions` section after Chart-time dependency approval and before I-B Activate.
- The section states these rules: pre-mortem per step, baseline before a performance target, criterion critic, pre-approved fallbacks, bump rule, environment check, and retrospective input.
- `ravintio-zero/templates/initiative.template.md` adds `## Decisions`, `## Baselines`, and `## Criteria` tables after `## Dependencies`.
- The I-A Chart section names the new tables where it lists what Chart collects.

## Acceptance Criteria
- [ ] AC-1: the standards state the rules
  - Given the roadmap standards
  - When a test reads the Chart-time decisions section
  - Then it names the pre-mortem, baseline, criterion critic, fallback, bump rule, environment check, and retrospective input
- [ ] AC-2: the template holds the tables
  - Given the initiative template
  - When a test reads it
  - Then `## Decisions`, `## Baselines`, and `## Criteria` follow `## Dependencies` and precede `## Steps`
- [ ] AC-3: Chart names the tables
  - Given the I-A Chart section
  - When a test reads it
  - Then it names the three tables

## Dependencies
- none
