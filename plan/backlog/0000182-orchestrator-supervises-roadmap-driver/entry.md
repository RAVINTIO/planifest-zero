---
title: "Backlog Entry: 0000182 - the orchestrator supervises the roadmap driver"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000182 - the orchestrator supervises the roadmap driver

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

The session that starts `ravintio-zero/scripts/roadmap-run.mjs` has no orchestrator role. The human on the loop expects it to be the orchestrator and to report when the roadmap completes. Three things stop it:

- R-E Delivery runs in the last child session. That session raises the roadmap PR and ends. The roadmap standard gives the parent session no duty to report the result.
- `plan/.orchestrator-ack` holds one session id, and each child writes its own. The strict-mode hook then tells the parent on every prompt that the orchestrator isn't confirmed. The parent can't fix that without overwriting the child's id.
- If the parent loads the orchestrator, resume detection finds the child's `plan/current/` and resumes that step. Two sessions would then run one step.

During roadmap 0000168, the parent session ran without the orchestrator and without phase prefixes (see 0000181).

## Suggested Action

- Define a supervisor mode in the orchestrator for the session that runs the driver. In that mode, resume detection skips `plan/current/` while the driver holds its lock, and the session doesn't edit the working tree.
- Let strict mode accept a supervisor ack beside the child's ack, for example `plan/.orchestrator-supervisor`, so neither session overwrites the other.
- When the driver exits, the supervisor reads the roadmap and the step logs. It then reports to the human:
  - each step's version and tag
  - any `Blocked:` stop and its build log line
  - the roadmap PR URL from R-E Delivery
- Report progress to the human at least once every 5 minutes while the driver runs. Each report names:
  - the step and its phase
  - the last build log line and the time it was written
  - the commits since the last report
  - any stop
  If nothing changed, say so and give the time since the last change.
- Give supervisor messages a prefix, such as `R-C Run:` while steps run and `R-E Delivery:` for the final report.
- Have R-B Activate start the driver from the orchestrator in supervisor mode, rather than offering it as a separate step.

## Wanted outcome

The session that starts the driver runs as the orchestrator in supervisor mode throughout. The supervisor reports progress at least once every 5 minutes. The strict-mode hook stays quiet in both the supervisor and child sessions. When the driver exits, the supervisor reports every step's result and the roadmap PR URL. A test runs the driver with a stub child and checks that the supervisor report names each step.

## Why Deferred

The human asked for it while roadmap 0000168 step 4 was running. It pairs with 0000181.
