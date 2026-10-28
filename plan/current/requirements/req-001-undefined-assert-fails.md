---
title: "Requirement: req-001 - undefined assert fails"
summary: "A call to an undefined assert function fails the suite, and assert_not_contains exists."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - undefined assert fails

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see a suite fail when it calls an undefined `assert_*` function, so that a negative check never runs as no check.

## Functional Requirements
- `helpers/assert.sh` defines `assert_not_contains needle haystack message`, which passes when the needle is absent.
- A call to an undefined function whose name starts with `assert_` prints a `FAIL` line that names the function.
- `print_summary` counts each such call as a failure and exits 1.
- A name that does not start with `assert_` keeps the shell default behaviour.

## Acceptance Criteria
- [ ] AC-1: undefined assert fails the suite
  - Given a suite that sources a copy of the helpers without `assert_not_contains`
  - When the suite calls `assert_not_contains` and then `print_summary`
  - Then the suite prints a `FAIL` line and exits non-zero
- [ ] AC-2: assert_not_contains checks absence
  - Given the shipped helpers
  - When `assert_not_contains` runs with an absent needle and with a present needle
  - Then the first call passes and the second fails

## Dependencies
- None.
