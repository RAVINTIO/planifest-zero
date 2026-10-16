---
title: "Discovery - 0000034-setup-hardening"
summary: "Raw P0 discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000034-setup-hardening

> Created at the start of P0, before the first coaching question, in every adoption mode.
> Raw findings only; decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so; coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features, and `docs/about.md` exists |
| Git pre-flight | `main` at `ca46469` after the PR #6 merge, human confirmed. Branch `feat/0000034-setup-hardening` created |
| Skills inbox | No `planifest-framework/skills-inbox/` folder, so empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.4.0`
- Prior features (`plan/_archive/`):
  - 0000031-five-phase-planifest-zero (2026-08-30): the 5-phase product
  - 0000032-relocate-setup-config-to-plan-state (2026-09-05): setup record moves to `plan/state/`
  - 0000033-remove-telemetry-mcp (2026-10-16): telemetry removed, legacy wiring cleanup added
- Constraining ADRs (unless superseded):
  - 0000033 ADR-001: `planifest-framework/` is out of scope for product features
  - 0000033 ADR-002: setup removes legacy telemetry wiring
  - 0000033 ADR-003: `product.yml` keeps its `id`
  - 0000032 ADR-001 to ADR-003: setup record path, refresh source order, inline cleanup
- Component / data-ownership map (`docs/`): one product component, `planifest-zero`, which owns no data.
- Pending migrations: none. `planifest-framework/migrations/` holds only scripts and `_done/`.
- Stale marker: the root `.feature-id` reads `0000031-five-phase-planifest-zero`. Backlog 0000096 covers it.
