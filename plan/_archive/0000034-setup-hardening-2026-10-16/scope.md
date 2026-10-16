---
title: "Scope - setup-hardening"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.4.1"
---
# Scope - setup-hardening

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md)
**Feature:** 0000034-setup-hardening
**Wave:** not waved
**Version:** 0.4.1

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- `planifest-zero/setup.sh` and `setup.ps1` accept four retired flags with one warning each: `--structured-telemetry-mcp`, `--backend-url <url>`, `--context-mode-mcp`, and `--include-full-skill-library` (req-001).
- `setup.sh` validates the tool name by exact match (req-002).
- Every `settings.json` write in both setup scripts goes through `settings.json.planifest-tmp` and a rename (req-003).
- `remove_legacy_telemetry_wiring` in `setup.sh` warns when `node` is missing and `settings.json` exists (req-004).
- Delete the root `.feature-id` (req-005).
- Add `human request` to `planifest-zero/templates/backlog-entry.template.md` (req-006).
- New test suites under `planifest-zero/tests/` for req-001 to req-006, and updates to any existing suite these changes break.
- Living docs and `component.yml` updated to 0.4.1.

## Out of Scope

- `planifest-framework/` (0000033 ADR-001).
- `planifest-refresh-setup`. The human chose to fix 0000092 in setup.
- Atomic writes for the boot file, the flags marker, and the setup record.
- The PowerShell parity gaps in backlog 0000090 and 0000094.
- The garbled banner line in `setup.sh` main output.

## Deferred

- A `pwsh` test runner (part of backlog 0000084). Until it exists, `setup.ps1` changes in req-001 and req-003 get static checks only, and their runtime behaviour stays untested.
