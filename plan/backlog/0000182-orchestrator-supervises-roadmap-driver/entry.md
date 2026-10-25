---
title: "Backlog Entry: 0000182 - a roadmap skill coordinates roadmap delivery"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000182 - a roadmap skill coordinates roadmap delivery

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

Nothing coordinates a roadmap from start to finish. The orchestrator coordinates one feature. The driver, `ravintio-zero/scripts/roadmap-run.mjs`, is a script that starts one step session after another. The human talks to the session that starts the driver, and that session has no defined role.

During roadmap 0000168, this caused these problems:

- **No final report.** R-E Delivery runs in the last step session. That session raises the roadmap PR and exits, so nothing reports the result to the human.
- **Strict-mode warnings.** `plan/.orchestrator-ack` holds one session id, and each step session writes its own. The strict-mode hook then warned the human's session on every prompt. That session couldn't fix the warning without overwriting the step session's id.
- **Unsafe resume.** If the human's session loads the orchestrator, resume detection finds the step's `plan/current/` and resumes that step. Two sessions would then run one step.
- **No progress view.** The human had to ask for progress. During step 4, the build log stayed unchanged for 25 minutes while the step kept committing.
- **No safe place for backlog entries.** The working tree was on the step's feature branch. Entries 0000179 to 0000182 went into the step 4 PR as a result.

The driver also showed three bugs:

1. **Missed stop.** Step 1's ship archived the plan before its CI run failed. The `Blocked:` line went to the archived build log, and the driver read only `plan/current/build-log.md`. It started step 2 anyway.
2. **Early advance.** R-D Advance marked step 1 `merged` and moved `position` before the merge took place.
3. **Lost subagents.** A `claude -p` session stops its background subagents after 10 minutes by default. Step 2 lost work this way until the human's session set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0`. The driver doesn't set it.

## Suggested Action

Add a `ravintio-roadmap` skill. It coordinates a roadmap the way the orchestrator coordinates a feature.

### The three parts

| Part | What it is | Runs where | Owns |
|------|-----------|------------|------|
| `ravintio-roadmap` skill | The roadmap coordinator | The human's session | Chart, activate, watch the steps, report progress, deliver |
| Driver, `roadmap-run.mjs` | A script with no AI | A background task that the roadmap skill starts | Start each step session in turn, and stop on a `Blocked:` line |
| `ravintio-orchestrator` skill | The feature coordinator | Each step session, a separate `claude -p` process | One feature from P0 to P4, then the merge into the roadmap branch |

The human talks only to their own session. Step sessions run with no human present.

### How a roadmap runs

1. **R-A Chart.** The roadmap skill plans the steps with the human and takes their approval.
2. **R-B Activate.** The roadmap skill cuts the roadmap branch and starts the driver.
3. **R-C Run.** The driver starts a step session. It loads the orchestrator and builds one feature from P0 to P4.
4. **R-D Advance.** The step session merges its feature PR into the roadmap branch, tags the merge commit, and exits.
5. The driver starts the next step session. Stages R-C and R-D repeat until no steps remain.
6. While steps run, the roadmap skill watches the build log and git, and reports to the human. It never edits the working tree.
7. **R-E Delivery.** After the driver exits, the roadmap skill archives the roadmap and raises the roadmap PR to `main`. It then gives the final report.

### Changes

- **Move roadmap stages out of the orchestrator.** R-A Chart, R-B Activate, and R-E Delivery move to the roadmap skill. The orchestrator and ship skills keep R-C Run and R-D Advance.
- **Split resume detection.** The orchestrator never resumes a roadmap. The roadmap skill resumes a roadmap and never resumes a step. A session that starts with an active roadmap and the driver's lock held loads the roadmap skill.
- **Split the ack files.** The roadmap skill writes `plan/.roadmap-ack`, and a step session writes `plan/.orchestrator-ack`. The strict-mode hook accepts either, so it stays quiet in both sessions.
- **Trigger the right skill.** The auto-trigger hook loads the roadmap skill for roadmap work and the orchestrator for feature work. Both skills keep the same hard limits.
- **Explain the parts.** `ravintio-zero/standards/roadmap-standards.md` and `ravintio-zero/project-operations.md` both gain the table of the three parts and the run sequence above.
- **Report progress.** While the driver runs, the roadmap skill reports at least once every 5 minutes. Each report names:
  - the step and its phase
  - the last build log line and when it was written
  - the commits since the last report
  - any stop
  - whether the driver process is still running

  If nothing changed, the report says so and gives the time since the last change.
- **Report events at once.** When the build log gains a phase `Complete:`, a `Blocked:`, or a `Resolved:` line, the roadmap skill reports it without waiting for the next 5-minute report. When it moves to a new build log, it also reports the `Complete:` lines already there. During roadmap 0000168, those lines went unreported for step 6's P0 and P1.
- **Answer progress requests.** On request and at each phase end, give a report in two parts:
  - **Roadmap:** steps merged out of the total, and backlog entries done out of the total, with a table of each step's feature, entries, version, and status.
  - **Current step:** the phase, progress within it, and what comes next. Progress is units done out of planned in P2, and criteria verified out of total from P3. Add highlights, such as what the step changes for the user, and any risk.
- **Flag a stale log.** If the step keeps committing but its build log hasn't changed for 15 minutes, say so in the report.
- **Use a Claude Code monitor.** A read-only background monitor checks every 30 seconds. It prints one line per event and a heartbeat every 5 minutes. A monitor expires after 30 minutes, so the roadmap skill starts a new one until the driver exits.
- **Queue backlog entries.** While a step runs, the roadmap skill holds new backlog entries outside the working tree. It commits them to the roadmap branch after the step merges. Ids come from the counter that 0000183 adds.
- **Use the `R-` prefixes.** The roadmap skill uses `R-C Run:` while steps run and `R-E Delivery:` for the final report.
- **Fix the driver bugs:**
  1. Read the newest archived build log as well as `plan/current/build-log.md`, and stop on an unresolved `Blocked:` line in either.
  2. Mark a step `merged` and move `position` only after the merge commit exists.
  3. Set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` in each step session's environment, unless the human has already set it.

## Wanted outcome

The human's session runs the roadmap skill from chart to delivery. It reports progress at least every 5 minutes, at each phase end, and on request, and it gives the final report with the roadmap PR URL. Strict mode stays quiet in the human's session and in every step session. The driver stops on a `Blocked:` line in an archived build log, marks a step merged only after its merge, and keeps step subagents running.

Tests check these conditions:

- A driver run with a stub step session produces a final report that names each step.
- A `Blocked:` line in an archived build log stops the driver.
- `position` doesn't move before the merge commit exists.
- Each step session's environment holds `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0`.
- The strict-mode hook stays quiet in both sessions when each has written its own ack file.

## Why Deferred

The human asked for it while roadmap 0000168 step 4 was running. It pairs with 0000181 (phase prefixes) and 0000183 (id counter). RAVINTIO Framework backlog 0000245 holds the same design.
