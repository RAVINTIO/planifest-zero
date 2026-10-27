---
title: "Backlog Entry: 0000225 - chart plans each step confirmation"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000225 - chart plans each step confirmation

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

Initiative 0000195 step 13 ran the `ravintio-refresh-setup` skill. That skill asks the human to confirm the setup command at Step 4 (`ravintio-zero/skills/ravintio-refresh-setup/SKILL.md` line 60). A step session has no human to answer.

The first step 13 session stopped at that confirmation and never ran P0. The branch sat idle from 13:13 to 18:04 UTC. The human then added a standing approval as override `custom-006` (commit `9214ada`). The re-run took 26 minutes, out of 317 for the whole step.

Chart did not list the confirmations that step 13's skills ask for. The `## Decisions` table in `ravintio-zero/standards/roadmap-standards.md` (line 138) covers forks, but not confirmations inside a skill.

## Suggested Action

At chart, list each confirmation that a step's skills ask for. For each one, record a pre-approval with the exact command in `initiative.md`, or plan a human stop for that step. The rule lives in the I-A Chart section of `roadmap-standards.md` and in the `## Decisions` table.

## Wanted outcome

- A test reads the confirmation rule in the I-A Chart section of `roadmap-standards.md`.
- The `## Decisions` table in the initiative template has a row form for a step confirmation.
- A chore step whose skill asks for a confirmation runs with no stop when chart pre-approved it.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. The initiative had already delivered, so no step could take it in.
