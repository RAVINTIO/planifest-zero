---
title: "Requirement: REQ-001 - setup-ps1-speed-target"
summary: "Total setup.ps1 time across both Windows CI jobs falls from 210 s to under 105 s."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - setup-ps1-speed-target

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** US-001 (backlog 0000159)
**Priority:** must-have

## User Story

As a maintainer, I wait less for the Windows CI jobs, so that a pull request gets its PowerShell result sooner.

## Functional Requirements
- CI run `40106508296` measured 210.1 s of `setup.ps1` time over 111 cases across both Windows jobs.
- The total across both jobs falls under 105 s for the step's pull request CI run.
- The `[timing] setup.ps1` lines and the REQ-003 total measure it. The measured span stays the same: one child host start plus the setup run.
- The gain comes from REQ-002, the move of the per-file copy away from cmdlet calls (ADR-002).
- A local profile on `pwsh` 7 shows the skill copy falls by at least half of its 427 ms baseline.

## Acceptance Criteria
- [ ] AC-1: CI total under half
  - Given the step pull request's CI run with both Windows jobs green
  - When the maintainer adds the two `[timing] setup.ps1 total` values from the job logs
  - Then the sum is under 105000 ms
- [ ] AC-2: Local skill copy at least halves
  - Given a fresh workspace on macOS `pwsh` 7
  - When a profile run times `Copy-RavintioSkills` before and after the change
  - Then the after time is at most half the before time

## Dependencies
- REQ-002 makes the change that this requirement measures.
- REQ-003 prints the total that AC-1 reads.
