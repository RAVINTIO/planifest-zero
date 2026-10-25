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
- REQ-004 replaces the bundle rules. Setup installs only each skill's own files from `ravintio-zero/skills/{skill}/`, and no pack template, standard, or schema.
- Console output stays line for line the same.
- The code uses only APIs that .NET Framework 4.5 has, so Windows PowerShell 5.1 runs it.

## Acceptance Criteria
- [ ] AC-1: Installed tree matches the bundle rules
  - Given a fresh workspace under Windows PowerShell 5.1 or PowerShell 7
  - When a test runs `setup.ps1 claude-code` and walks `.claude/skills/`
  - Then every file in the skill's source folder exists with the same bytes, and no other file exists
  - And each SKILL.md matches its source after the path rewrite
- [ ] AC-2: Rerun overwrites in place
  - Given a workspace with an installed tree and one installed skill file changed by hand
  - When a test runs `setup.ps1 claude-code` again
  - Then the file matches its source again and the tree still matches the skill source folders
- [ ] AC-3: Hooks and output unchanged
  - Given a fresh workspace
  - When a test runs `setup.ps1 claude-code`
  - Then each hook module under `.claude/hooks/` matches its source bytes
  - And the output holds a `+ {skill}/SKILL.md` line for each skill in source order

## Dependencies
- None
