---
title: "Recommendations - 0000033-remove-telemetry-mcp"
summary: "P6 recommendations, deferred items, and tech debt filed for this feature."
status: "draft"
version: "0.1.0"
---
# Recommendations - 0000033-remove-telemetry-mcp

**Skill:** [docs-agent](../../.claude/skills/planifest-docs-agent/SKILL.md)
**Feature:** 0000033-remove-telemetry-mcp
**Date:** 2026-10-16

## Deferred Items

Items judged out of scope for this feature on purpose, with the reasoning already recorded elsewhere in this feature's own artifacts.

| Item | Reference | Status |
|------|-----------|--------|
| The PowerShell changes have static test coverage only. That covers `Remove-LegacyTelemetryWiring` and the P5 fixes (`-cmatch` matching and link-only deletion of a reparse-point marker). `pwsh` is not installed on the build machine, and no PowerShell suite runs through `planifest-zero/tests/run-tests.sh`. | Build log P5 entry. Already tracked as backlog 0000084. | Referenced, not refiled. |
| `test-0000031-req-001-rename.sh` still fails its two assertions about `planifest-framework/` existing, identical to `main`. The human overrode the P4 gate past it on 2026-10-15. | Build log P4 entry, Risk R-005 in `plan/current/risk-register.md`. Already tracked as backlog 0000086. | Referenced, not refiled. |
| `planifest-refresh-setup` replays `--structured-telemetry-mcp` from an old flags marker, and `setup.sh` now exits 1 on it. Fixing it means choosing how setup treats retired flags, which is a design decision outside this feature's scope. | Security report, out-of-scope finding. | Filed as backlog 0000092. |
| `planifest-framework/` keeps its telemetry, and so does this repo's CI job `validate-telemetry-schema` in `.github/workflows/planifest.yml`. The next refresh of the framework copy from `planifest-zero/` removes the telemetry that job guards. The job then has nothing to validate. | ADR-001 decisions 4 and 5. The `design.md` Dependencies section names the refresh as downstream. Backlog 0000089 covers the refresh but not the CI job. | Proposed for the backlog, not yet filed. |

## Tech Debt

Acknowledged debt found or left in place during this feature, filed alongside the code that carries it.

| Item | Reference | Status |
|------|-----------|--------|
| `setup.ps1` wires four enforcement hooks, not six. `ratchet-check` and `em-dash-guard` appear nowhere in the script. The gap predates this feature and holds on `main`. | Build log P3 entry. | Filed as backlog 0000090. |
| Both setup scripts rewrite `.claude/settings.json` in place, so a write that stops partway can truncate it. `setup.sh` also skips the settings cleanup without a warning when `node` is missing. | Security report Threat Model and Bash and PowerShell Parity sections. | Filed as backlog 0000091. |
| `setup.ps1` wraps a non-array hook event value in an array when it rewrites `settings.json`. `setup.sh` leaves it alone. This is the one remaining parity gap the backlog does not cover. | Security report, Bash and PowerShell Parity section. | Proposed for the backlog, not yet filed. |
| The legacy telemetry cleanup runs on every setup invocation with no end date. Once no project carries telemetry wiring, it is dead code that still runs each time. | ADR-002 Negative Consequences. | Proposed for the backlog, not yet filed. |

## Recommendations

- A re-run of `setup.sh` prints `- removed: planifest-orchestrator` and eleven more skill-prune lines. All twelve skills are present afterwards. P4 confirmed the same output on `main`, so this feature did not cause it. The lines suggest a deletion that did not happen. Change the prune step so it reports only skills that stay deleted. This is a recommendation only, with no backlog entry.
- Before the next feature edits `setup.ps1`, give it an automated runner, as backlog 0000084 proposes. This feature added a cleanup function and two P5 security fixes to that script, and no test executes any of them.

## Deliberate Absence: No per-component `docs/` folder

This run produced no `src/{component-id}/docs/` tree and none of the nine per-component artifacts a docs-agent run normally writes. The cause is the structure of this repository, not a gap left by this run.

`planifest-zero/` is the product this repository ships. It is also the single component that `product.yml` declares, through `planifest-zero/component.yml`. Features 0000031 and 0000032 followed the same structure, and this feature keeps it. `planifest-zero/component.yml`, `planifest-zero/pipeline-reference.md`, and `planifest-zero/project-operations.md` carry the documentation role that per-component docs would otherwise hold.

## Other Notes for the Ship Agent

- `product.yml` still reads `version: "0.3.0"` and `feature: "0000032-relocate-setup-config-to-plan-state"`. Under `versionPolicy: max-component-version`, `node planifest-zero/scripts/product-version.mjs` derives `0.4.0` from `planifest-zero/component.yml`. Update both fields at ship.
- ADR-003 is at v0.2.0 after the P5 reversal of decisions 4 and 5. `product.yml` keeps its top-level `id`, and orchestrator step 9 keeps the hard stop with a versioning reason. The PR description should say the product id stays, because v0.1.0 of the same ADR removed it.
- `req-005-drop-product-id-gate.md` keeps its original filename so links stay valid, although the requirement now keeps the gate.
- ADR-002 is at v0.1.1 after the P5 security fix. Its decision 1 now states the `<module>.mjs` path-boundary rule.
- Risk register R-001 to R-006 carry no Status column values. The security report marks R-001 mitigated and A-003 as holding. Set the statuses before archiving.
