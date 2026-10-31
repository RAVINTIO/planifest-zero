---
title: "Backlog Entry: 0000265 - stop step sessions moving the driver logs"
summary: "A coordinator-observed defect, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000265 - stop step sessions moving the driver logs

**Source feature:** none (initiative 0000238 supervision)
**Source phase:** none (initiative 0000238 supervision)
**Deferral source:** coordinator observation
**Date filed:** 2026-10-28

---

## Problem

During initiative 0000238 step 9, `plan/.initiative-logs/` was missing from the working tree for at least 10 minutes, from about 20:10 UTC on 2026-10-28. It came back later with its original file dates, so the step session most likely moved it aside and then restored it.

Two tests, `test-0000042-req-006` (a) and `test-0000043` (c), fail while the folder holds text from a step's own searches. Steps 7 and 8 reran them in a scratch copy. Step 9 appears to have hidden the real folder instead.

While the folder was missing:

- The watcher couldn't relay the step's activity.
- The driver had nowhere to write the step log. A write failure could have stopped the run.
- The coordinator couldn't read the stop evidence for steps 1 to 9.

## Suggested Action

- Add a rule to the orchestrator and initiative skills. A step session never moves, renames, or deletes driver files, such as `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, and `plan/.initiative-queue/`.
- Remove the reason for the workaround. Entry 0000264 makes those two tests skip `plan/.initiative-logs/`.

## Wanted outcome

No step session moves or removes driver files. Tests check these conditions:

- The orchestrator skill names the driver files that a step must leave in place.
- After a full suite run inside a step, `plan/.initiative-logs/` still holds every step log.

## Why Deferred

The coordinator found it while initiative 0000238 step 9 was in P2. The charted steps don't cover it. Entry 0000264 covers the test half of the cause.
