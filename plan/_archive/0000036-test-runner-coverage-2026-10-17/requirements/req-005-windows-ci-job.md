---
title: "Requirement: req-005 - windows-ci-job"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - windows-ci-job

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Source:** US-005, backlog 0000084
**Priority:** must-have

## User Story

As a reviewer, I open a PR, so that CI runs the PowerShell suites on Windows PowerShell 5.1 and PowerShell 7.

## Functional Requirements
- `.github/workflows/planifest.yml` gains a `windows-powershell` job on `windows-latest`.
- It runs `tests/run-tests.ps1` once with `powershell` and once with `pwsh`, as two steps whose names say which host runs.
- The job sets read-only `contents` permission and uses no secrets.

## Acceptance Criteria
- [ ] The job exists with both host steps and `permissions: contents: read`.
- [ ] The job passes on the PR for this feature.
- [ ] Each step's log names the host and its version.

## Dependencies
- req-003, req-004
