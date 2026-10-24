---
title: "Requirement: req-008 - quiet-test-output"
summary: "PLANIFEST_TEST_QUIET=1 hides passing output in all four test files and keeps every failure detail, and skills that run the full suite use it."
status: "draft"
version: "0.1.0"
---
# Requirement: req-008 - quiet-test-output

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (token efficiency, backlog 0000148 change 3)
**Priority:** must-have

## User Story

As the person paying for runs, I want the full test suite to print only what I need, so that a passing run does not fill the context with 200 KB of `PASS:` lines.

## Functional Requirements
- Setting `PLANIFEST_TEST_QUIET=1` changes the output of these four files:
  - `planifest-zero/tests/helpers/assert.sh`
  - `planifest-zero/tests/helpers/assert.ps1`
  - `planifest-zero/tests/run-tests.sh`
  - `planifest-zero/tests/run-tests.ps1`
- In quiet mode, the files hide `PASS:` lines and the `--- name ---` suite banners.
- In quiet mode, the files still print:
  - every `FAIL:` line with its expected and actual values, or its needle and haystack
  - the failing suite's name, once, before its first `FAIL:` line
  - the final summary
- Quiet mode leaves all exit codes unchanged.
- `Assert-Contains` in `assert.ps1` prints the needle and the haystack when it fails. This applies with and without quiet mode.
- The headers of `run-tests.sh` and `run-tests.ps1` document `PLANIFEST_TEST_QUIET` beside `PLANIFEST_PWSH`, `PLANIFEST_REQUIRE_PWSH`, and `PLANIFEST_PREFLIGHT_ONLY`.
- These skills run the full suite with `PLANIFEST_TEST_QUIET=1`:
  - `planifest-refactor` (lines 15 and 39 to 42)
  - `planifest-validate-and-accept`, where it names the test command in its CI process
  - any other skill that runs the full suite, found by grepping `planifest-zero/skills/` for `run-tests`
- Without the variable, output stays as it is today.

## Acceptance Criteria
- [ ] (a) Quiet mode behaviour. Every check below holds.
  - With `PLANIFEST_TEST_QUIET=1`, a passing `assert.sh` suite and a passing `assert.ps1` suite print no `PASS:` line. Each prints its summary and exits 0.
  - With `PLANIFEST_TEST_QUIET=1`, a failing assertion in a fixture suite still prints its `FAIL:` line and its expected and actual values. The output also names the failing suite before the first `FAIL:` line. A test checks this for the bash and PowerShell helpers.
  - The same fixture suite exits with the same non-zero code in quiet and normal mode. A passing fixture exits 0 in both.
  - A failing `Assert-Contains` prints its needle and haystack in normal and quiet mode.
- [ ] (b) Unchanged normal mode. Every check below holds.
  - With the variable unset, the fixture output matches the output before this change, including `PASS:` lines and banners.
- [ ] (c) Documentation and existing suites. Every check below holds.
  - The `run-tests.sh` and `run-tests.ps1` headers mention `PLANIFEST_TEST_QUIET`. A test greps for it.
  - `planifest-refactor/SKILL.md`, `planifest-validate-and-accept/SKILL.md`, and every other skill that runs the full suite name `PLANIFEST_TEST_QUIET=1` in the command. A test greps each file that contains `run-tests`.
  - The existing suites pass in normal and quiet mode with no assertion removed or relaxed.

## Non-functional requirements
- A passing full run of `PLANIFEST_TEST_QUIET=1 bash planifest-zero/tests/run-tests.sh` prints under 10 KB. The measure is `| wc -c`, and the 0000148 baseline is 208,724 bytes.

## Dependencies
- Banners come from `run_one` in `run-tests.sh`. The quiet suite-name line must survive the banner suppression, so the suite name prints only before a first failure.
- Files in reach:
  - `planifest-zero/tests/helpers/assert.sh`
  - `planifest-zero/tests/helpers/assert.ps1`
  - `planifest-zero/tests/run-tests.sh`
  - `planifest-zero/tests/run-tests.ps1`
  - `planifest-zero/skills/planifest-refactor/SKILL.md`
  - `planifest-zero/skills/planifest-validate-and-accept/SKILL.md`
  - `planifest-zero/tests/test-0000151-req-008-quiet-test-output.sh` (new, uses a temporary failing suite)
- REQ-015 adds per-case timing output to the CI run. That output must not break quiet mode.
