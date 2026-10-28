---
title: "Scope - plan checks count and cap tests"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - plan checks count and cap tests

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000246-plan-checks-count-and-cap-tests
**Version:** 0.35.0

## In Scope

- A `## Test impact scan` section in `ravintio-zero/skills/ravintio-plan/SKILL.md`.
- A `## Test impact` section in `ravintio-zero/templates/execution-plan.template.md`.
- A test, `test-0000246-req-001-test-impact-scan.sh`, that checks both.
- Count updates in existing tests that this step's own additions break.
- Docs, changelog and version updates for 0.35.0.

## Out of Scope

- A script that runs the scan.
- Edits to the count, budget, cap or id tests beyond count updates.

## Deferred

Nothing deferred.
