---
title: "Requirement: req-015 - faster-powershell-ci"
summary: "The windows-powershell job runs 5.1 and 7 as a parallel matrix, and the test helpers print per-case timing."
status: "draft"
version: "0.1.0"
---
# Requirement: req-015 - faster-powershell-ci

**Skill:** [plan](../../../planifest-zero/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-010 (backlog 0000150)
**Priority:** should-have

## User Story

As a contributor, I wait less for CI, so that I get feedback sooner.

## Functional Requirements
- The `windows-powershell` job in `.github/workflows/planifest.yml` (lines 49-71) runs 5.1 and 7 as two steps in one job. Replace them with a two-entry matrix so both run in parallel.
  - One entry uses `shell: powershell` (Windows PowerShell 5.1). The other uses `shell: pwsh` (PowerShell 7).
  - `fail-fast` is `false`, so a failure in one entry does not cancel the other.
  - The job keeps `runs-on: windows-latest`, `permissions: contents: read`, the checkout pinned to a commit, and `persist-credentials: false`.
  - The job uses no secrets.
- The workspace helpers print per-case timing.
  - `New-SetupWorkspace` (`planifest-zero/tests/helpers/setup-workspace.ps1`, lines 33-44) prints the workspace copy time.
  - `Invoke-Setup` (lines 58-73) prints the `pwsh` start-up time and the `setup.ps1` run time.
  - Timing lines go to the host output, never into captured data that a test asserts on.
- The PowerShell suites stay in the Linux `bash-suites` job, and `PLANIFEST_REQUIRE_PWSH` stays `"1"` there.
- Batching several cases per `pwsh` process is deferred. The timing output decides it later, and this requirement does not build it.
- NFR: the `windows-powershell` wall time is below the slower of the two sequential steps today (about 2 to 4.5 minutes for the 7 step).
- `planifest-zero/tests/test-0000036-req-005-windows-ci-job.sh` moves to the matrix shape and keeps the intent of every assertion.

## Acceptance Criteria
- [ ] (a) Matrix and job settings hold:
  - The job block defines a `strategy.matrix` with exactly two entries, one for each shell, and `fail-fast: false`.
  - The job block still contains `runs-on: windows-latest`, `contents: read`, no `secrets.` reference, one `actions/checkout@` line pinned to a 40-character commit, and `persist-credentials: false`.
  - Both shells run `planifest-zero/tests/run-tests.ps1`: the job text holds `shell: powershell` and `shell: pwsh` (as a matrix value or step), and exactly one `run-tests.ps1` invocation runs per matrix entry.
- [ ] (b) Existing tests and timing output hold:
  - `test-0000036-req-005-windows-ci-job.sh` is updated for the matrix. Each existing assertion keeps its check (job exists, windows-latest, contents read, no secrets, both shells, pinned checkout, persist-credentials false, workflow-level contents read). Only the literal-line and "exactly 2 run-tests.ps1 lines" checks change shape.
  - `test-0000037-req-006-bash-suites-ci-job.sh` passes unchanged, and the `bash-suites` job still sets `PLANIFEST_REQUIRE_PWSH` to `"1"`.
  - A run of a setup-workspace test case prints three timing lines: workspace copy, `pwsh` start-up, and `setup.ps1`. Existing assertions on helper output still pass.
- [ ] (c) Wall time and gate strength hold:
  - The feature PR's `windows-powershell` wall time is below the slower of today's two steps. P3 records the measured time.
  - The matrix gate is no weaker: both entries must pass for the job to pass.

## Dependencies
- None on other requirements in this feature.
- The deferral on batching depends on P2 timing from (f).
- Files in reach:
  - `.github/workflows/planifest.yml` (`windows-powershell` job, lines 49-71)
  - `planifest-zero/tests/helpers/setup-workspace.ps1` (`New-SetupWorkspace`, `Invoke-Setup`)
  - `planifest-zero/tests/test-0000036-req-005-windows-ci-job.sh` (update to the matrix shape)
  - `planifest-zero/tests/test-0000037-req-006-bash-suites-ci-job.sh` (existing, check only)
  - `planifest-zero/tests/run-tests.ps1` (check only)
