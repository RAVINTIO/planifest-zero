---
title: "Backlog Entry: 0000235 - keep each attempt's step log when the driver re-runs a step"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000235 - keep each attempt's step log when the driver re-runs a step

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

The driver deletes the evidence of a failed step attempt when it re-runs the step. In initiative 0000195, the first step 13 session stopped at the `ravintio-refresh-setup` confirmation. The human added a standing approval, and the driver ran step 13 again. `plan/.initiative-logs/step-13.log` holds only the re-run's 13 lines. The first session's stop text is gone, so the retrospective could not quote it.

The cause is in `ravintio-zero/scripts/initiative-run.mjs`. Its `openLog` function opens `step-{position}.log` with `O_TRUNC`. The header comment states the rule: "Each step start will truncate its log, so a rerun leaves only the latest attempt." `ravintio-zero/standards/roadmap-standards.md` repeats it. `ravintio-zero/tests/test-0000151-req-012-roadmap-step-logs.sh` asserts it in case (a), "a rerun truncates the log".

## Suggested Action

- Before the driver opens a step log, rename an existing `step-{n}.log` to the next free `step-{n}.attempt-{k}.log`. Then open a fresh `step-{n}.log`, so the latest attempt keeps the same name.
- Apply the same symlink refusals and modes to the attempt files: folder 700, file 600.
- Name every attempt log in the driver's stop line.
- Update the roadmap standard and the req-012 test to the new rule.

This entry covers only the file on a re-run. Backlog entry 0000219 covers what goes into the log while a step runs.

## Wanted outcome

A re-run never loses an earlier attempt's log. Driver tests check these conditions:

- A step that runs twice leaves `step-1.attempt-1.log` with the first output and `step-1.log` with the second.
- A step that runs three times leaves `attempt-1` and `attempt-2` files and a current `step-1.log`, each with its own output.
- An attempt file has mode 600, and a symlink at an attempt path stops the driver with the symlink refusal.
- A step that runs once leaves only `step-1.log`.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. This entry holds one of them.
