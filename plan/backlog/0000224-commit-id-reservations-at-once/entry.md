---
title: "Backlog Entry: 0000224 - commit each id reservation at once"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000224 - commit each id reservation at once

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

During initiative 0000195 step 13, the human's session reserved ids 0000214 to 0000216 with `reserve-id.mjs`. It left the change to `plan/backlog/.next-id` uncommitted while the step ran. Step 13 then reserved 0000214 on its own branch and committed it. The human's entry became 0000215 (commit `d57472d`).

`ravintio-zero/scripts/reserve-id.mjs` locks the counter file, but the lock covers only one working tree. An uncommitted reservation does not protect an id from a session on another branch.

Several skills tell the agent to leave a reservation uncommitted:

- `ravintio-zero/skills/ravintio-retrospective/SKILL.md` line 61 says to leave the entry uncommitted if no run is active.
- `ravintio-zero/skills/ravintio-postmortem/SKILL.md` line 56 says the same.
- `ravintio-zero/skills/ravintio-initiative/SKILL.md` line 73 reserves queue ids but commits only when the entries move.

## Suggested Action

Commit the counter change as soon as `reserve-id.mjs` returns, in step sessions and in the human's session. One way is a `--commit` flag on the script that commits `plan/backlog/.next-id` alone. The skills that reserve ids then use it. The entry itself can stay uncommitted where a skill says so.

## Wanted outcome

- A test runs `reserve-id.mjs` in a temp repo and finds the counter change in a new commit.
- The commit holds `plan/backlog/.next-id` and no other path.
- A test reads the commit rule in the initiative, retrospective, and postmortem skills.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. The initiative had already delivered, so no step could take it in.
