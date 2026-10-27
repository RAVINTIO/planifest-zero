---
title: "Backlog Entry: 0000227 - restart the driver after a tooling change"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000227 - restart the driver after a tooling change

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

Initiative 0000195 step 10 changed `ravintio-zero/scripts/initiative-run.mjs` and added `ravintio-zero/scripts/initiative-watch.mjs` and the `ravintio-initiative` skill (PR #48, merged at 12:07 UTC). The old driver kept running steps 11 to 15. The **Notes for chart** section of `initiative.md` recorded that later steps keep the stage rules from activation.

The human's session had no progress watcher. The human asked three times for an update. The driver also loads its code once, so a step can't change how later steps run.

## Suggested Action

After a step merges, the driver checks whether the step changed any of these:

- `initiative-run.mjs`
- `initiative-watch.mjs`
- `ravintio-zero/skills/ravintio-initiative/SKILL.md`

If one changed, the driver restarts itself before the next step. Or it stops and asks the initiative skill to restart it. Either way, later steps run the new code.

## Wanted outcome

- A driver test changes `initiative-run.mjs` in a step and sees the next step run under a new driver process.
- A test changes the watcher or the initiative skill in a step and sees a restart or a stop that names the change.
- A step that changes none of the three files gives no restart.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. The initiative had already delivered, so no step could take it in.
