---
title: "Requirement: req-002 - userpromptsubmit-parity"
summary: "setup.sh matches UserPromptSubmit commands with the same path-boundary rule as setup.ps1."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - userpromptsubmit-parity

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Source:** US-002 (backlog 0000111)
**Priority:** must-have

## User Story

As a user on any platform, I run either setup script, so that both remove the same entries from my `settings.json`.

## Functional Requirements
- `setup.sh` matches `UserPromptSubmit` commands with the case-sensitive path-boundary rule that `setup.ps1` uses (0000035 S-004).
- `setup.sh` no longer matches by bare substring, such as `includes("check-design")`.
- Both scripts read the same planted fixtures in their suites.

## Acceptance Criteria
- [ ] (a) The user commands `node ./tools/my-check-design-helper.sh` and `node ./tools/Check-Design.mjs` survive both scripts.
- [ ] (b) Every `UserPromptSubmit` command shape an earlier setup wrote is still removed, so no Planifest entry appears twice.
- [ ] (c) `setup.ps1` gives the same entries as `setup.sh` on every req-001 and req-002 fixture, on Windows PowerShell 5.1 and PowerShell 7.

## Dependencies
- req-001 changes the same filter to work per command.
