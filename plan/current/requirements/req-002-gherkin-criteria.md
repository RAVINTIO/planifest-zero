---
title: "Requirement: REQ-002 - gherkin-criteria"
summary: "The requirement template and plan skill write each acceptance criterion as a checkbox line with Given, When, and Then steps."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - gherkin-criteria

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Source:** US-002 (backlog 0000165)
**Priority:** must-have

## User Story

As a test writer, I read each acceptance criterion as `Given`, `When`, and `Then` lines, so that each test maps to one criterion line by line.

## Functional Requirements
- Today `ravintio-zero/templates/requirement.template.md` writes each criterion as free text after `- [ ]`.
- The template writes each criterion as `- [ ] AC-{n}: {short name}`.
- Under each checkbox line, the template adds indented lines `  - Given ...`, `  - When ...`, and `  - Then ...`.
- `And` and `But` continue the step above them.
- A criterion stays one checkbox line (ADR-003). The test writer and the P3 coverage table keep that unit.
- The `ravintio-plan` requirements rules state the format. They also state that the three-criteria limit counts checkbox lines, not steps.
- The `## Functional Requirements` and `## Acceptance Criteria` headings stay unchanged. A 0000010 test checks them.

## Acceptance Criteria
- [ ] AC-1: Template shows the format
  - Given `ravintio-zero/templates/requirement.template.md`
  - When a test reads its `## Acceptance Criteria` section
  - Then it holds a line matching `- [ ] AC-{n}:` followed by indented `Given`, `When`, and `Then` bullets
- [ ] AC-2: Skill states the format and the limit
  - Given `ravintio-zero/skills/ravintio-plan/SKILL.md`
  - When a test searches the requirements rules
  - Then the rules name the `AC-{n}` format and `And`/`But` continuation, and say the limit counts checkbox lines, not steps
- [ ] AC-3: Headings stay
  - Given the edited template
  - When the 0000010 structure test runs
  - Then it passes, and the template still holds `## Functional Requirements` and `## Acceptance Criteria`

## Dependencies
- REQ-003 checks criteria written in this format.
- REQ-005 guards the step lines this format creates.
- REQ-001 shares the plan skill file.
