---
title: "Scope - test suite reliability"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - test suite reliability

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Version:** 0.30.2

## In Scope

- `assert_not_contains` and the undefined-assert failure in `ravintio-zero/tests/helpers/assert.sh`.
- `stale_install_skip_reason` in the same file, used by section (c) of `test-0000151-req-014`.
- One new suite that covers both helpers.
- A line in the tests README about both behaviours.

## Out of Scope

- Changes to setup or to how it installs skills.
- Other suites that call `assert_*` helpers.
- A PowerShell mirror, because `helpers/assert.ps1` has no matching helpers.

## Deferred

Nothing deferred.
