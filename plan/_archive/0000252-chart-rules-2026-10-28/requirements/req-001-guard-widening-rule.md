---
title: "Requirement: REQ-001 - guard-widening rule"
summary: "Chart names the guard and the new forms when an entry widens a fail-closed hook, and needs a separate approval."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - guard-widening rule

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000252-chart-rules
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see chart name the guard and the new forms when an entry widens what a fail-closed hook lets through, and ask me to approve each widening on its own, so that no chart weakens a guard unseen.

## Functional Requirements
- The I-A Chart section of `roadmap-standards.md` has a guard check that runs on each backlog entry of each step.
- The rule names `merge-guard`, `gate-write`, and `ratchet-check`, and covers any other fail-closed hook.
- If an entry widens a guard, chart names the guard and the new forms the guard would allow.
- The rule needs a separate human approval for each widening entry. The chart confirmation never covers one.
- If the human does not approve, chart cuts the entry back to a fix that widens nothing, or strikes the step.
- `ravintio-initiative/SKILL.md` holds the same rule in its Chart section.
- The rule adds chart text only. No file under `ravintio-zero/hooks/` changes.

## Acceptance Criteria
- [ ] AC-1: the standard holds the guard check
  - Given the I-A Chart section of `roadmap-standards.md`
  - When the test reads it
  - Then it finds the three guard names, the words "any other fail-closed hook", and a separate approval for each widening
- [ ] AC-2: the initiative skill holds the same rule
  - Given the Chart section of `ravintio-initiative/SKILL.md`
  - When the test reads it
  - Then it finds a guard check that names a separate approval
- [ ] AC-3: the hooks stay unchanged
  - Given the diff of this feature against the initiative branch
  - When P3 lists the changed paths
  - Then no path under `ravintio-zero/hooks/` appears

## Dependencies
- none
