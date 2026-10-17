---
title: "Requirement: req-001 - per-command-filter"
summary: "Setup removes only Planifest commands from a hook entry and keeps the user's commands."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - per-command-filter

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Source:** US-001 (backlog 0000112, 0000037 security finding S-001)
**Priority:** must-have

## User Story

As a user with my own hook in a shared entry, I rerun setup, so that my command survives and only the Planifest commands change.

## Functional Requirements
- `setup.sh` and `setup.ps1` filter `PreToolUse` and `UserPromptSubmit` entries one command at a time.
- A command is Planifest when it runs one of that event's modules as `<module>.mjs` at a path boundary, matched case-sensitively.
  - `PreToolUse` modules: `gate-write`, `ratchet-check`, and `em-dash-guard`.
  - `UserPromptSubmit` modules: `auto-trigger-orchestrator`, `check-orchestrator-presence`, and `check-design`.
- Setup removes each Planifest command from an entry and keeps the other commands in their order.
- If an entry had commands and none remain, setup drops the entry.
- An entry with no commands, or with a non-array `hooks` value, stays as it was.
- Setup then appends the fresh Planifest entries, as it does today.

## Acceptance Criteria
- [ ] (a) An entry holding `gate-write.mjs` and a user command keeps only the user command, with its matcher, after either script runs.
- [ ] (b) An entry holding only Planifest commands is gone, and each fresh Planifest entry appears exactly once.
- [ ] (c) A `UserPromptSubmit` entry holding `check-design.mjs` and a user command keeps only the user command.
- [ ] (d) A second run produces a byte-identical `settings.json`.
- [ ] (e) `setup.ps1` gives the same result as `setup.sh` on fixtures (a) to (c), on Windows PowerShell 5.1 and PowerShell 7.

## Dependencies
- req-002 shares the `UserPromptSubmit` filter in `setup.sh`. Build req-002's matching rule into the same filter.
