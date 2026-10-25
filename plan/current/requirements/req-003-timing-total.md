---
title: "Requirement: REQ-003 - timing-total"
summary: "run-tests.ps1 prints the total setup.ps1 time and case count for the run."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - timing-total

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** US-003 (backlog 0000159)
**Priority:** must-have

## User Story

As a maintainer, I read one timing total per run from `run-tests.ps1`, so that I can check the speed target without summing log lines.

## Functional Requirements
- `run-tests.ps1` creates a new empty timing file in the temp folder and sets `RAVINTIO_TIMING_FILE` to its path for the suites it starts (ADR-003).
- `Invoke-Setup` in `helpers/setup-workspace.ps1` appends one line per run to that file, holding the elapsed milliseconds. If the variable is unset, it appends nothing.
- After the last suite, the runner prints `[timing] setup.ps1 total: {ms} ms over {n} cases` before the summary block. The runner prints it in quiet mode too.
- The runner deletes the timing file at the end, including when a suite fails.
- The per-case `[timing]` lines stay as they are.
- The timing file holds numbers only, never test output.

## Acceptance Criteria
- [ ] AC-1: Runner prints the total
  - Given a test folder with two stub suites that each append one value to `RAVINTIO_TIMING_FILE`
  - When a test runs `run-tests.ps1` from that folder
  - Then the output holds `[timing] setup.ps1 total:` with the sum of both values and `over 2 cases`
- [ ] AC-2: Helper appends one line per run
  - Given `RAVINTIO_TIMING_FILE` set to an empty file
  - When a test calls `Invoke-Setup` twice
  - Then the file holds two lines, each a whole number
- [ ] AC-3: Timing file cleaned up
  - Given a stub suite that fails
  - When a test runs `run-tests.ps1` from that folder
  - Then the runner exits 1 and the timing file it named no longer exists

## Dependencies
- None
