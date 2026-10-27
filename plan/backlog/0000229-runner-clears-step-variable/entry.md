---
title: "Backlog Entry: 0000229 - the test runners clear the step variable"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000229 - the test runners clear the step variable

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

The initiative driver `ravintio-zero/scripts/initiative-run.mjs` sets `RAVINTIO_INITIATIVE_STEP=1` in every step session. Tests run inside that session inherit it. The hooks `check-orchestrator-presence.mjs` and `auto-trigger-orchestrator.mjs` read it, so hook tests saw a step session they did not expect. The variable broke hook tests in three steps:

- Step 13 (0000208) had 2 hook ack failures on its first run. They passed 32 of 32 with the variable unset (`plan/.initiative-logs/step-13.log`, `plan/retrospectives/0000208-refresh-setup-record-2026-10-27.md`).
- Step 14 (0000217) ran the full suite with the variable unset to get a clean result (`step-14.log`, `plan/_archive/0000217-verify-codex-setup-2026-10-27/build-log.md`).
- Step 15 (0000218) saw its new suite fail inside the step session (`plan/_archive/0000218-strict-hook-follows-active-skill-2026-10-27/build-log.md`, P2 rework line).

Step 15 added `env -u RAVINTIO_INITIATIVE_STEP` to two suites only. Those are `test-0000205-req-002-ack-and-trigger-hooks.sh` and `test-0000218-req-001-002-skill-owner-banner.sh`. Neither runner clears the variable. `ravintio-zero/tests/run-tests.sh` starts each suite with `bash` or `pwsh` in the caller's environment. `ravintio-zero/tests/run-tests.ps1` does the same with its host program. Any hook suite added later meets the same failure.

## Suggested Action

Clear `RAVINTIO_INITIATIVE_STEP` in both runners before they start any suite. Do this for feature suites and regression suites. A suite that needs the variable sets it for its own hook call, as the two step 15 suites already do. The per-suite `env -u` calls may stay or go.

## Wanted outcome

Tests check these conditions:

- `RAVINTIO_INITIATIVE_STEP=1 bash ravintio-zero/tests/run-tests.sh` passes every suite that passes with the variable unset.
- The same holds for `run-tests.ps1` with `$env:RAVINTIO_INITIATIVE_STEP = '1'`.
- A probe suite run through each runner sees the variable as unset.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`.
