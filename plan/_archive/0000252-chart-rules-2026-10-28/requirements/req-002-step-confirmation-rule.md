---
title: "Requirement: REQ-002 - step confirmation rule"
summary: "Chart lists each confirmation that a step's skills ask for and records a pre-approval or plans a human stop."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - step confirmation rule

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000252-chart-rules
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see chart list each confirmation that a step's skills ask for and record a pre-approval with the exact command or plan a human stop, so that no step session waits for an answer that nobody gives.

## Functional Requirements
- The I-A Chart section of `roadmap-standards.md` has a confirmation rule. For each step, chart reads the skills the step loads and lists each point where a skill asks the human to confirm.
- For each confirmation, chart records a pre-approval with the exact command in `## Decisions`, or plans a human stop for that step.
- The `## Decisions` table in `initiative.template.md` has a row form for a step confirmation. Its Fork column starts with `Confirmation:`.
- I-C Run says that a confirmation which matches a `Confirmation:` row runs the row's exact command with no stop, and the step logs it. A command that differs in any way stops the step.
- `ravintio-initiative/SKILL.md` holds the confirmation rule in its Chart section.

## Acceptance Criteria
- [ ] AC-1: the standard holds the confirmation rule
  - Given the I-A Chart section of `roadmap-standards.md`
  - When the test reads it
  - Then it finds the confirmation listing, the exact command pre-approval, and the human stop
- [ ] AC-2: the template has a confirmation row form
  - Given `initiative.template.md`
  - When the test reads its `## Decisions` table
  - Then it finds a row whose Fork starts with `Confirmation:`
- [ ] AC-3: a pre-approved confirmation does not stop a step
  - Given the I-C Run section of `roadmap-standards.md`
  - When the test reads it
  - Then it finds that a matching `Confirmation:` row runs with no stop and that a differing command stops

## Dependencies
- none
