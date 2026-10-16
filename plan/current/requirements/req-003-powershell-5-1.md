---
title: "Requirement: req-003 - powershell-5-1"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - powershell-5-1

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Source:** US-003, backlog 0000105
**Priority:** must-have

## User Story

As a Windows user on the built-in PowerShell 5.1, I run `setup.ps1`, so that it adds `Agent` to `allowedTools` without a PowerShell 7 feature.

## Functional Requirements
- `Merge-AllowedTools` reads `settings.json` with plain `ConvertFrom-Json` and edits the resulting object.
- It keeps every existing key and every existing `allowedTools` entry, and adds `Agent` once.
- If `settings.json` is missing or doesn't parse, it starts from an empty object, as today.
- `setup.ps1` and `setup/*.ps1` use no `-AsHashtable`.

## Acceptance Criteria
- [ ] `setup.ps1` and `setup/*.ps1` contain no `-AsHashtable`.
- [ ] `Merge-AllowedTools` still calls `Write-SettingsAtomic` and still checks for an existing `Agent` entry.

## Dependencies
- None
