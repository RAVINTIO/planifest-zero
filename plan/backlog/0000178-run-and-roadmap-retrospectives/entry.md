---
title: "Backlog Entry: 0000178 - add retrospectives at the end of a run and a roadmap"
summary: "A human-requested capability, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000178 - add retrospectives at the end of a run and a roadmap

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

The build report at ship lists metrics and a few notes, but no step reviews what went well and what to change. A roadmap ends at R-E Delivery with no review across its steps. Lessons stay in build logs that nobody rereads, so the next run repeats the same friction.

## Suggested Action

Add a blameless retrospective at two points:

- **Run:** at ship, after the build report. Review what helped, what slowed the run, and what to try next. Read the build log, the self-corrections, the stops, and any postmortems from backlog entry 0000177.
- **Roadmap:** at R-E Delivery, across every step. Compare the charted plan with what shipped, and look for friction that repeated across steps.

Each improvement becomes a backlog entry or a repo instruction, with its source retrospective named. Store retrospectives outside `plan/current/`, for example in `plan/retrospectives/`, so a later run can read them at P0.

## Wanted outcome

Every shipped run and every delivered roadmap has a retrospective record. Each record names at least one thing to keep and one to change, and each change links to a filed action. P0 discovery reads the latest retrospectives.

## Why Deferred

The human asked for it while roadmap 0000168 was running. It pairs with backlog entry 0000177.
