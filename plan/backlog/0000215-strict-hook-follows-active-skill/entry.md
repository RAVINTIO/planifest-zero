---
title: "Backlog Entry: 0000215 - strict-mode hook asks for the skill that owns the session"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000215 - strict-mode hook asks for the skill that owns the session

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

The strict-mode hook (`ravintio-zero/hooks/enforcement/check-orchestrator-presence.mjs`) decides which skill to ask for by the driver lock, `plan/.initiative-runner.lock`. The lock is a poor signal for which skill owns a session:

- Between steps, and after the driver exits, the lock is free. The human's session then gets the orchestrator banner while an initiative is active. Loading the orchestrator there is unsafe, because its resume detection would take over a step.
- During initiative 0000195 step 13, the human's session got the orchestrator banner first. It asked for `plan/.orchestrator-ack`, which the step session owns and commits with its P0 artifacts.
- Neither `plan/.orchestrator-ack` nor `plan/.initiative-ack` is git-ignored. A step session that stages `plan/` can commit the human's ack.

## Suggested Action

Decide the banner by which skill owns the session:

- If `plan/current-initiative/initiative.md` has `status: active` and `RAVINTIO_INITIATIVE_STEP` is not `1`, ask for the `ravintio-initiative` skill and `plan/.initiative-ack`. The driver lock doesn't change this.
- If `RAVINTIO_INITIATIVE_STEP` is `1`, or no initiative is active, ask for the `ravintio-orchestrator` skill and `plan/.orchestrator-ack`.

Apply the same rule to the auto-trigger hook, so both hooks always name the same skill. Add `plan/.initiative-ack` to `.gitignore`.

## Wanted outcome

The orchestrator banner appears only when the orchestrator runs outside an initiative, or inside a step session. Tests check these conditions:

- An active initiative with the lock free and no step variable gives the initiative banner.
- An active initiative with the lock held and no step variable gives the initiative banner.
- A step session gives the orchestrator banner.
- No active initiative gives the orchestrator banner.
- The auto-trigger hook names the same skill as the strict-mode hook in each of these cases.
- `git check-ignore plan/.initiative-ack` succeeds.

## Why Deferred

The human asked for it during initiative 0000195 step 13. The initiative session can't edit the working tree while a step runs, so it queued the entry.
