---
title: "Scope - driver step fixes"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - driver step fixes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Version:** 0.39.1

## In Scope

- `unset RAVINTIO_INITIATIVE_STEP` in `run-tests.sh` and the matching removal in `run-tests.ps1`, before any suite starts.
- A rotation step in `openLog` of `initiative-run.mjs`, with the same symlink refusals and modes.
- Attempt logs named in the driver's stop line.
- The new log rule in the driver header, `roadmap-standards.md`, and `test-0000151-req-012-roadmap-step-logs.sh` case (a).
- Two tests: `test-0000251-req-001-runners-clear-step-variable.sh` and `test-0000251-req-002-keep-attempt-logs.sh`.
- Docs, changelog, and version updates for 0.39.1.

## Out of Scope

- What the driver writes into the log while a step runs.
- A cap on the number of attempt logs, or pruning of old attempts.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- Removal of the per-suite `env -u RAVINTIO_INITIATIVE_STEP` calls.

## Deferred

Nothing deferred.
