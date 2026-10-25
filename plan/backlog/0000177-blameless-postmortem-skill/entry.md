---
title: "Backlog Entry: 0000177 - add a blameless postmortem skill"
summary: "A human-requested capability, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000177 - add a blameless postmortem skill

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

The pipeline fixes a failure and moves on. Nothing asks why the earlier phases let it through, so the same kind of failure returns.

Roadmap 0000168 shows the pattern. Step 1 stopped on a `setup.ps1` bug that P3 passed locally. Step 3 stopped twice in CI, on a Windows PowerShell 5.1 encoding bug and a missed speed target. Each stop got a fix and a `Resolved:` line, but no root cause. The driver also missed a `Blocked:` line, and that gap has no record.

## Suggested Action

Add a `ravintio-postmortem` skill. Port RAVINTIO Framework backlog entry 0000085 and keep its method:

- **Trigger:** a failed CI run, a `Blocked:` stop, a P2 self-correction that a test should have caught, an escaped defect, or a human request.
- **Method:** blameless rules, a timeline with evidence, and 5 whys. The whys stop at a gap in a process, check, standard, or tool, never at a person or agent.
- **Output:** corrective, preventive, and detective actions. Each names its owner, where it lives, and what verifies it.
- **Filing:** each action becomes a backlog entry or a repo instruction.
- **Record:** `plan/postmortems/`, outside `plan/current/`, so ship's archive step leaves it in place.

Have the orchestrator run it after a `Resolved:` line, before ship. Have the build report list the run's postmortems.

## Wanted outcome

After a run with a CI failure or a `Blocked:` stop, `plan/postmortems/` holds one record per stop. Each record has a timeline, a 5 whys chain ending at a process or tool gap, and at least one filed action.

## Why Deferred

The human asked for it while roadmap 0000168 was running. RAVINTIO Framework holds the same request as backlog entry 0000085.
