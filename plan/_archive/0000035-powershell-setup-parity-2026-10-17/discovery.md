---
title: "Discovery - 0000035-powershell-setup-parity"
summary: "Raw P0 discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000035-powershell-setup-parity

> Created at the start of P0, before the first coaching question, in every adoption mode.
> Raw findings only; decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so; coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features, and `docs/about.md` exists |
| Git pre-flight | PR #7 (0000034) is open and unmerged. Branch `feat/0000035-powershell-setup-parity` starts from `40e00ac`, the PR #7 head |
| Skills inbox | `planifest-framework/skills-inbox/` is empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.4.1`
- Prior features (`plan/_archive/`):
  - 0000032-relocate-setup-config-to-plan-state (2026-09-05): setup record moves to `plan/state/`
  - 0000033-remove-telemetry-mcp (2026-10-16): telemetry removed, legacy wiring cleanup added
  - 0000034-setup-hardening (2026-10-16): retired flags warn, atomic `settings.json` writes
- Constraining ADRs (unless superseded):
  - 0000033 ADR-001: `planifest-framework/` is out of scope for product features
  - 0000034 ADR-001: retired flags warn and continue
  - 0000034 ADR-002 v0.1.1: atomic `settings.json` writes through `settings.json.planifest-tmp`
- Component / data-ownership map (`docs/`): one product component, `planifest-zero`, which owns no data.
- Pending migrations: none.
- Tooling: no `pwsh` or `powershell` on this machine or in CI, so PowerShell changes get static checks only.

## Backlog findings for this release

- 0000090: `setup.ps1` wires four enforcement hooks. `setup.sh` wires six. `ratchet-check` and `em-dash-guard` are missing.
- 0000094: `Remove-LegacyTelemetryWiring` wraps a non-array hook event value in an array. `setup.sh` skips it with `Array.isArray`.
- 0000104: a hard stop can leave `.claude/settings.json.planifest-tmp` behind until the next write.
- 0000105: `Merge-AllowedTools` uses `ConvertFrom-Json -AsHashtable`, which Windows PowerShell 5.1 lacks. The flag `switch` ignores case. No other PowerShell 7-only syntax appears in `setup.ps1` or `setup/*.ps1`.
- `setup.sh` wires each `PreToolUse` hook as two entries, one for `Write` and one for `Edit`. `setup.ps1` wires `gate-write` as one `Write|Edit` entry.
