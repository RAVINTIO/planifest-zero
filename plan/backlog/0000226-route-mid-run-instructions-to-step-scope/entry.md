---
title: "Backlog Entry: 0000226 - route mid-run instructions into step scope"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000226 - route mid-run instructions into step scope

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

During initiative 0000195 step 13, the human asked for a standing approval as a repo instruction. The initiative session tried to write the override from the human's session. The `gate-write` hook blocked the write, as designed.

The human then put the override into the step 13 scope instead. Task 1 of the **Step 13 chore** section in `initiative.md` adds `custom-006-standing-setup-refresh-approval.md` (commit `9214ada`). The step wrote the file, and the re-run finished with no further stop.

The `ravintio-initiative` skill has no rule for this case. Its queue rule (`ravintio-zero/skills/ravintio-initiative/SKILL.md` line 73) covers backlog entries only.

## Suggested Action

Add a rule to the initiative skill. If the human asks for a repo instruction while a step runs, the skill adds it to the scope of the current or next pending step in `initiative.md`. The skill never writes the instruction from the initiative session.

The `gate-write` hook must stay as it is.

## Wanted outcome

- A test reads the routing rule in `ravintio-zero/skills/ravintio-initiative/SKILL.md`.
- The rule names `initiative.md` as the target and the current or next pending step as the scope.
- The `gate-write` hook and its tests stay unchanged.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. The initiative had already delivered, so no step could take it in.
