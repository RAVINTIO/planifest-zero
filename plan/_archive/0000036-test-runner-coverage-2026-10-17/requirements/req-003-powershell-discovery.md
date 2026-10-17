---
title: "Requirement: req-003 - powershell-discovery"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - powershell-discovery

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Source:** US-003, backlog 0000084
**Priority:** must-have

## User Story

As a maintainer, I add a `test-*.ps1` suite, so that the runner runs it, or says loudly that it skipped it.

## Functional Requirements
- `run-tests.sh` discovers `test-*.ps1` in `tests/` and `tests/regression/`.
- If `pwsh` is on the `PATH`, it runs each with `pwsh -NoProfile -File` and counts it like a bash suite.
- If not, it prints `Skipped N PowerShell suites: pwsh not found` once. With `PLANIFEST_REQUIRE_PWSH=1`, it also counts that as a failure.
- A new `tests/run-tests.ps1` runs every `test-*.ps1` in both folders under the host that started it, prints a summary, and exits 1 on any failure.

## Acceptance Criteria
- [ ] With `pwsh` hidden from the `PATH`, a run prints the skip line with the right count and keeps today's exit code.
- [ ] With `pwsh` hidden and `PLANIFEST_REQUIRE_PWSH=1`, the run exits 1.
- [ ] With a fake `pwsh` on the `PATH`, the runner calls it once per `.ps1` suite and counts its exit codes.

## Dependencies
- None
