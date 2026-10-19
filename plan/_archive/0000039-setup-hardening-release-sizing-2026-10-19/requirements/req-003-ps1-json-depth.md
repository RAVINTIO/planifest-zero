---
title: "Requirement: req-003 - ps1-json-depth"
summary: "setup.ps1 writes settings.json with a JSON depth of 100 so deep values survive."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - ps1-json-depth

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Source:** US-003 (backlog 0000115)
**Priority:** must-have

## User Story

As a Windows user with deeply nested settings, I run `setup.ps1`, so that no nested value is cut.

## Functional Requirements
- Every `ConvertTo-Json` call in `setup.ps1` that writes or prints `settings.json` content uses `-Depth 100`.
  - These are the hook install step, the allowedTools step, and the non-array warning that prints the old value.
- A value nested 15 levels deep survives unchanged.
- Calls that write other files, such as the marker file, are out of scope.
- Settings writes stay atomic through `Write-SettingsAtomic` (0000034 ADR-002).

## Acceptance Criteria
- [ ] A value nested 15 levels deep in `settings.json` survives `setup.ps1` unchanged.

## Dependencies
- req-001 and req-002 change the same install step in `setup.ps1`.
