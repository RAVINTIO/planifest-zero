---
title: "Scope - powershell-setup-parity"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.4.2"
---
# Scope - powershell-setup-parity

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Wave:** not waved
**Version:** 0.4.2

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- `setup.ps1` wires `ratchet-check` and `em-dash-guard`, in the `setup.sh` entry shape (req-001).
- A static parity suite that compares the hook modules each script wires (req-001).
- `Remove-LegacyTelemetryWiring` skips a non-array event value (req-002).
- `Merge-AllowedTools` drops `-AsHashtable` (req-003).
- The `setup.ps1` flag `switch` becomes case-sensitive (req-004).
- Both scripts remove a leftover `.claude/settings.json.planifest-tmp` at the start of each run (req-005).
- New suites under `planifest-zero/tests/`, and updates to any existing suite these changes break.
- Living docs and `component.yml` updated to 0.4.2.

## Out of Scope

- `planifest-framework/` (0000033 ADR-001).
- A `pwsh` test runner (backlog 0000084).
- Non-array guards in `Merge-EnforcementHookSettings`.
- The `setup.sh` `PreToolUse` filter, which keeps a `Write|Edit` entry that an older `setup.ps1` wrote.

## Deferred

- Runtime tests of `setup.ps1`. Until a `pwsh` runner exists, req-001 to req-005 get static checks on the PowerShell side.
