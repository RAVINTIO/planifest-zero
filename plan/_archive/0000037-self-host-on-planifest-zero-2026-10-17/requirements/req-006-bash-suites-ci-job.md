---
title: "Requirement: req-006 - bash-suites-ci-job"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-006 - bash-suites-ci-job

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-004, backlog 0000108
**Priority:** must-have

## User Story

As the maintainer, I see the Bash suites run in CI, so that a PR can't break one and still show green checks.

## Functional Requirements
- `.github/workflows/planifest.yml` gains a `bash-suites` job on `ubuntu-latest`.
- The job runs `bash planifest-zero/tests/run-tests.sh` with `PLANIFEST_REQUIRE_PWSH=1`. The image has `pwsh`, so the job also runs the PowerShell suites on Linux.
- The job sets `permissions: contents: read` and uses no secrets.
- The job pins `actions/checkout` to the same commit as `windows-powershell`, with `persist-credentials: false`.
- Rewrite the `## CI` section of `planifest-zero/tests/README.md` to describe the `bash-suites` job.
- A new suite, `planifest-zero/tests/test-0000037-req-006-bash-suites-ci-job.sh`, checks the job block. It follows `test-0000036-req-005-windows-ci-job.sh`, and it skips in a consumer copy with no repo workflow.

## Acceptance Criteria
- [ ] The `bash-suites` job exists on `ubuntu-latest` with `PLANIFEST_REQUIRE_PWSH=1`, `contents: read`, and a checkout pinned to a 40-character commit.
- [ ] The job uses no secrets and sets `persist-credentials: false`.
- [ ] The new suite passes locally, and `test-0000036-req-005-windows-ci-job.sh` still passes.
- [ ] The job passes on the PR for this feature, and every other CI job stays green (AC 10, 11).

## Dependencies
- req-004. The job fails until req-004 removes `planifest-framework/` and the rename suite passes, so req-006 runs last in P3.
- req-001, because both edit `.github/workflows/planifest.yml`.
