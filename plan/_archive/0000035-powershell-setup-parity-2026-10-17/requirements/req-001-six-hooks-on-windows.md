---
title: "Requirement: req-001 - six-hooks-on-windows"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - six-hooks-on-windows

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Source:** US-001, backlog 0000090
**Priority:** must-have

## User Story

As a Windows user, I run `setup.ps1`, so that it wires the same six enforcement hooks as `setup.sh`.

## Functional Requirements
- `Merge-EnforcementHookSettings` in `setup.ps1` writes six `PreToolUse` entries: `Write` then `Edit` for `gate-write.mjs`, `ratchet-check.mjs`, and `em-dash-guard.mjs`, in that order.
- It writes three `UserPromptSubmit` entries with matcher `.*`: `auto-trigger-orchestrator.mjs`, `check-orchestrator-presence.mjs`, and `check-design.mjs`, in that order.
- Each command is `node <hooks dir>/<module>.mjs`, as today.
- Before adding entries, it removes any `PreToolUse` entry whose hook command names `gate-write`, `ratchet-check`, or `em-dash-guard`, whatever its matcher.
- The function comment and `Install-EnforcementHooks` comment name all six hooks.

## Acceptance Criteria
- [ ] A static parity suite extracts the hook modules each script wires per event and finds the same list in the same order.
- [ ] The suite finds `Write` and `Edit` matchers for each `PreToolUse` module in `setup.ps1`, and no `Write|Edit` matcher.
- [ ] The `PreToolUse` filter in `setup.ps1` names all three `PreToolUse` modules.

## Dependencies
- None
