---
title: "Requirement: req-004 - setup-ps1-runtime-suites"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - setup-ps1-runtime-suites

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Source:** US-004, backlog 0000084
**Priority:** must-have

## User Story

As a Windows user, I rely on `setup.ps1`, so that its main behaviours run under test on both PowerShell versions.

## Functional Requirements
- A `tests/helpers/assert.ps1` gives `Assert-Equal`, `Assert-True`, and a summary that exits 1 on any failure.
- PowerShell suites run `setup.ps1 claude-code` in a temporary copy of the project and check:
  - six `PreToolUse` and three `UserPromptSubmit` Planifest entries, matching the 0000035 design table
  - a re-run over an old `Write|Edit` entry leaves no duplicate
  - non-ASCII text survives, with no BOM written
  - a wrong-case flag exits 1, and each retired flag warns and exits 0
  - a leftover temporary file goes, and a non-array hook value stays
  - `allowedTools` gains `Agent` once
- Suites skip nothing silently. A missing `node` is a failure.

## Acceptance Criteria
- [ ] Each behaviour in the list has at least one assertion.
- [ ] The suites pass in CI under Windows PowerShell 5.1 and PowerShell 7.
- [ ] A suite fails when its assertion is broken on purpose, checked once locally by review of the helper.

## Dependencies
- req-003 (the runner and `run-tests.ps1`)
