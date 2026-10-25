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

The human also had no regular view of progress. During step 4, the child's build log stayed unchanged for 25 minutes while it kept committing. The log's `In progress:` lines gave no sign of how close P2 was to complete.

Backlog entries filed by the parent while a step ran had nowhere safe to go. The working tree was on the child's feature branch. Entries 0000179 to 0000182 rode into the step 4 PR as a result. On the same day, two sessions gave the same RAVINTIO Framework backlog ids to different entries.

The driver also showed three bugs during roadmap 0000168:

1. **Missed stop.** Step 1's ship archived the plan before its CI run failed. The `Blocked:` line went to the archived build log, and the driver read only `plan/current/build-log.md`. It started step 2, and the step 2 session found the stop.
2. **Early advance.** R-D Advance marked step 1 `merged` and moved `position` before the merge took place. The roadmap then showed a step as merged with its PR still open.
3. **Lost subagents.** A `claude -p` child stops its background subagents after 10 minutes by default. Step 2 lost work this way until the parent set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0`. The driver doesn't set it.

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
- Answer a progress request at any time, and close each phase end with the same report. It has two parts:
  - **Roadmap:** steps merged out of the total, and backlog entries done out of the total, with a table of each step's feature, entries, version, and status.
  - **Current step:** the phase, progress within it (units done out of planned, and criteria verified out of total once P3 starts), and what comes next. Add highlights: what the step changes for the user, and any risk, such as criteria verified only by text search.
- Report at once, without waiting for the next 5-minute report, when the build log gains a phase `Complete:`, a `Blocked:`, or a `Resolved:` line.
- In Claude Code, a read-only background monitor does this. It checks every 30 seconds and prints one line per event and one heartbeat line every 5 minutes. A monitor expires after 30 minutes, so the supervisor starts a new one each time until the driver exits.
- Make each heartbeat show whether the driver process is still running, so a stopped driver never looks like a quiet one.
- Flag a stale build log. If the child keeps committing but its build log hasn't changed for 15 minutes, say so in the report.
- Give the supervisor a safe place to file backlog entries while a step runs. One option is to hold them in a queue outside the working tree and commit them to the roadmap branch after the step merges. Allocate each id against every branch, so two sessions can't take the same id.
- Fix the three driver bugs:
  1. Read the newest archived build log as well as `plan/current/build-log.md`, and stop on an unresolved `Blocked:` line in either.
  2. Mark a step `merged` and move `position` only after the merge commit exists.
  3. Set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` in each child's environment, unless the human has set it.
- Give supervisor messages a prefix, such as `R-C Run:` while steps run and `R-E Delivery:` for the final report.
- Have R-B Activate start the driver from the orchestrator in supervisor mode, rather than offering it as a separate step.

## Decision at P0

Should one orchestrator skill run both the roadmap workflow and the feature pipeline, or should they split into two skills?

- **One skill.** The orchestrator keeps the R-A to R-E stages and adds supervisor mode. It keeps one entry point, and the auto-trigger hook needs no change. The cost is a larger skill with two resume paths. Resume detection must also tell a supervisor from a step session.
- **Two skills.** A roadmap skill owns charting, the driver, supervision, progress reports, and governance across steps. The orchestrator keeps one feature run, P0 onwards. Each session then loads one skill with one resume path and its own ack. The cost is a second entry point. The auto-trigger hook must also pick the right skill, and the shared hard limits must stay in step across both.

The recommendation is two skills. The supervisor and the step session differ in resume detection, ack, prefixes, and reporting duty. A split keeps the orchestrator to one run, and gives roadmap reporting and governance one owner.

## Wanted outcome

The session that starts the driver runs as the orchestrator in supervisor mode throughout. On request and at each phase end, the supervisor reports roadmap completion and the current step's phase, progress, and highlights. It also reports progress at least once every 5 minutes and reports each phase end or stop at once. The driver stops on a `Blocked:` line in an archived build log, advances a step only after its merge, and keeps child subagents running. The strict-mode hook stays quiet in both the supervisor and child sessions. When the driver exits, the supervisor reports every step's result and the roadmap PR URL. A test runs the driver with a stub child and checks that the supervisor report names each step. Further tests cover each driver fix.

## Why Deferred

The human asked for it while roadmap 0000168 step 4 was running. It pairs with 0000181.
