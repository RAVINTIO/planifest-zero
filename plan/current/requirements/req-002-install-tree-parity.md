---
title: "Requirement: REQ-002 - install-tree-parity"
summary: "setup.ps1 copies skills and hooks with System.IO calls, and the installed tree and console output stay the same."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - install-tree-parity

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** US-002 (backlog 0000159)
**Priority:** must-have

## User Story

As a consumer, I run `setup.ps1` and get the same installed files as before, only faster, so that a refresh costs less time.

## Functional Requirements
- `Copy-RavintioSkills` copies files with `[System.IO.File]::Copy` and makes folders with `[System.IO.Directory]::CreateDirectory`. It checks paths with `System.IO` calls in place of `Test-Path` (ADR-002).
- A recursive folder copy keeps every file, including dot files such as `.gitkeep`, and every subfolder.
- A copy over an existing file overwrites it, the same as `Copy-Item -Force`.
- The SKILL.md path rewrite keeps `Get-Content` and `Set-Content -Encoding UTF8`. Each host keeps its own BOM behaviour.
- `Install-EnforcementHooks` copies the hook modules the same way.
- The bundle rules stay the same. A skill with `bundle_templates` gets only those templates, and a skill without the line gets all of them. Standards follow the same rule with top-level files only. Every skill gets all schemas.
- Console output stays line for line the same.
- The code uses only APIs that .NET Framework 4.5 has, so Windows PowerShell 5.1 runs it.

## Acceptance Criteria
- [ ] AC-1: Installed tree matches the bundle rules
  - Given a fresh workspace under Windows PowerShell 5.1 or PowerShell 7
  - When a test runs `setup.ps1 claude-code` and walks `.claude/skills/`
  - Then every file the bundle rules name exists with the same bytes as its source, and no other file exists
  - And each SKILL.md matches its source after the path rewrite
- [ ] AC-2: Rerun overwrites in place
  - Given a workspace with an installed tree and one installed template changed by hand
  - When a test runs `setup.ps1 claude-code` again
  - Then the template matches its source again and the tree still matches the bundle rules
- [ ] AC-3: Hooks and output unchanged
  - Given a fresh workspace
  - When a test runs `setup.ps1 claude-code`
  - Then each hook module under `.claude/hooks/` matches its source bytes
  - And the output holds a `+ {skill}/SKILL.md` line for each skill in source order

## Dependencies
- None
