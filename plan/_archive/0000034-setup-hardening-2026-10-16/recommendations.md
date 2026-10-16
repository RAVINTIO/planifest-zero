---
title: "Recommendations - 0000034-setup-hardening"
summary: "P6 recommendations, deferred items, and tech debt filed for this feature."
status: "draft"
version: "0.1.0"
---
# Recommendations - 0000034-setup-hardening

**Skill:** [docs-agent](../../.claude/skills/planifest-docs-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Date:** 2026-10-16

## Deferred Items

| Item | Reference | Status |
|------|-----------|--------|
| `setup.ps1` changes have static checks only, including `Write-SettingsAtomic` and the `File.Replace` swap. No `pwsh` runs the suites. | Scope Deferred section, R-001, security report S-003. | Referenced, already tracked as backlog 0000084. |
| `test-0000031-req-001-rename.sh` cases (a) and (b) still fail while `planifest-framework/` exists. | Build log P4 entry. | Referenced, already tracked as backlog 0000097. |

## Tech Debt

| Item | Reference | Status |
|------|-----------|--------|
| A leftover `settings.json.planifest-tmp` after a hard stop could be committed in a project that doesn't ignore `.claude/`. | Security report S-009. | Filed as backlog 0000104. |
| `setup.ps1` uses `ConvertFrom-Json -AsHashtable`, which Windows PowerShell 5.1 lacks, and its `--strict-orchestrator` switch ignores case unlike `setup.sh`. | Security report out-of-scope observations and S-008. | Filed as backlog 0000105. |

## Recommendations

- Pick up backlog 0000084 before the next feature that edits `setup.ps1`. This feature added two code paths there that no test runs.
- Retired flags now live in two lists, one per script. If a later release retires another flag, add it to both lists and to the req-001 suite.

## Deliberate Absence: No per-component `docs/` folder

`planifest-zero/` is the single component and the product itself, as in 0000031 to 0000033. `planifest-zero/component.yml` and the living docs carry the per-component role.

## Other Notes for the Ship Agent

- `product.yml` reads `version: "0.4.0"` and `feature: "0000033-remove-telemetry-mcp"`. `product-version.mjs` derives `0.4.1` from `planifest-zero/component.yml`. Update both fields at ship.
- ADR-002 is at v0.1.1 after the P5 fix.
