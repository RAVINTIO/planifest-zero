---
title: "Requirement: REQ-001 - runners clear the step variable"
summary: "Both test runners clear RAVINTIO_INITIATIVE_STEP before they start any suite."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - runners clear the step variable

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I run the full suite inside a step session and see the same result as outside it, so that I do not rerun suites by hand.

## Functional Requirements
- `ravintio-zero/tests/run-tests.sh` runs `unset RAVINTIO_INITIATIVE_STEP` before the pre-flight and before any suite, feature or regression.
- `ravintio-zero/tests/run-tests.ps1` removes `Env:RAVINTIO_INITIATIVE_STEP` before it starts any suite.
- Each runner header says that it clears the variable and that a suite which needs it sets it for its own hook call.
- The per-suite `env -u RAVINTIO_INITIATIVE_STEP` calls in the two step 15 suites stay.
- The tests README, if it describes the runner environment, says the same.

## Acceptance Criteria
- [ ] AC-1: a probe suite sees the variable unset
  - Given a runner copy in a temporary folder with one probe suite that records the variable
  - When the runner starts with `RAVINTIO_INITIATIVE_STEP=1`
  - Then the probe records the variable as unset
- [ ] AC-2: the PowerShell runner clears it too
  - Given the PowerShell runner and a probe suite
  - When the runner starts with `$env:RAVINTIO_INITIATIVE_STEP = '1'`
  - Then the probe records the variable as unset, or the check is skipped where `pwsh` is missing
- [ ] AC-3: the full suite gives the same result
  - Given a step session with the variable set to `1`
  - When `bash ravintio-zero/tests/run-tests.sh` runs
  - Then every suite that passes with the variable unset also passes

## Dependencies
- none
