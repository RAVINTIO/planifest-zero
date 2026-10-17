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

## Acceptance Criteria
- [ ] (a) A user command such as `node ./tools/my-check-design-helper.sh` survives `setup.sh` and `setup.ps1`.
- [ ] (b) A user command `node ./tools/Check-Design.mjs` survives both scripts, because the match is case-sensitive.
- [ ] (c) Every `UserPromptSubmit` command shape an earlier setup wrote is still removed, so no Planifest entry appears twice.
- [ ] (d) The source of `setup.sh` holds no bare-substring match for the three `UserPromptSubmit` modules.

## Dependencies
- req-001 changes the same filter to work per command.
