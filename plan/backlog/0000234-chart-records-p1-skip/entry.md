---
title: "Backlog Entry: 0000234 - chart records whether a step may skip P1"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000234 - chart records whether a step may skip P1

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

Steps 13, 14, and 15 of initiative 0000195 skipped P1 Plan. Each step decided that alone, and no chart row allowed it.

| Step | Feature id | Kind | Build log reason for the skip |
|------|------------|------|-------------------------------|
| 13 | `0000208-refresh-setup-record` | chore | "chore with a fixed spec in initiative.md" |
| 14 | `0000217-verify-codex-setup` | chore | "chore with a fixed spec in initiative.md" |
| 15 | `0000218-strict-hook-follows-active-skill` | feature | "the backlog entry fixes the spec" |

Steps 13 and 14 were chores with exact tasks in `initiative.md`, so the skip did little harm. Step 15 changed hook code: `check-orchestrator-presence.mjs` and `auto-trigger-orchestrator.mjs`. Its archive (`plan/_archive/0000218-strict-hook-follows-active-skill-2026-10-27/`) holds no `requirements/` folder and no `adr/` folder. Its build log also records two deviations in P2, including a changed rule in `auto-trigger-orchestrator.mjs`. No ADR records that decision.

The pack has no rule for this case. The Phase Skip Protocol in `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-session-commands.md` covers only a skip the human asks for. A step session has no human to ask. The `## Decisions` table in `ravintio-zero/templates/initiative.template.md` has no column for a P1 skip.

## Suggested Action

- Add a P1 skip column to the `## Steps` table in `initiative.template.md`, or a `P1 skip` row type to `## Decisions`. Each step gets `yes` or `no`, with a reason.
- Add a chart rule in `ravintio-zero/standards/roadmap-standards.md`. Chart allows a skip only for a chore with exact tasks, or a change with no code. The human confirms the column with the chart.
- Make a step session that skips P1 with no `yes` row stop with `I-C Run: Blocked`.
- Make the build log quote the chart row when a step skips P1.

## Wanted outcome

No initiative step skips P1 unless the human approved the skip at chart. Tests check these conditions:

- The initiative template has a P1 skip field per step, with a reason.
- The roadmap standard states which steps chart may mark as skippable.
- The orchestrator or initiative rules state that a step with no `yes` row and a P1 skip stops with `I-C Run: Blocked`.
- A build log line for a skipped P1 names the chart row.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. This entry holds one of them.
