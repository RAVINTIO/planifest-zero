---
title: "Backlog Entry: 0000274 - every change reaches the initiative branch as a titled PR"
summary: "A postmortem action, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000274 - every change reaches the initiative branch as a titled PR

**Source feature:** none (initiative 0000238 postmortems)
**Source phase:** none (human request)
**Deferral source:** postmortems `plan/postmortems/2026-10-31-initiative-history-has-untitled-commits.md` and `plan/postmortems/2026-10-31-step-4-content-test-failed-on-coordinator-entry.md`
**Date filed:** 2026-10-31

---

## Problem

The squash into `initiative/*` exists so that the merge commit to `main` reads as one commit per feature. In initiative 0000238, 23 of the 38 first-parent commits on the initiative branch were direct commits with other titles. Initiative 0000195 had 39 of 55.

The pack causes most of them. It tells the coordinator to commit these directly on the initiative branch:

- chart id reservations and backlog entries
- the activation and any reactivation
- queued backlog entries and scope edits (`ravintio-initiative/SKILL.md` lines 82 and 89)
- the archive and the retrospective at I-E Delivery (`roadmap-standards.md` lines 388 and 389)

Step 13 also committed its changelog PR number after its squash (`6f088d9`). Direct commits skip CI, so entry 0000257 broke a content test and stopped step 4.

## Suggested Action

- State in `roadmap-standards.md` that every commit on `initiative/*` arrives as a squashed PR. Nothing commits directly on the initiative branch.
- Give coordinator work a feature-style title that uses the initiative id, such as `0000238-delivery: archive, retrospective, and backlog entries (#n)`. Batch the work where it can wait, such as queued entries between steps.
- Decide who lands a coordinator PR. `merge-guard` allows the agent a squash into `initiative/*` only for its own feature PR after a clean P3. Don't widen `merge-guard`. If coordinator PRs don't qualify, the human lands them or they ride in the next step's PR.
- Make ship record the PR number before the squash, never after it.

## Wanted outcome

The first-parent history of every initiative branch is one titled squash per change. Tests check these conditions:

- The roadmap standards and the initiative skill name no direct commit on the initiative branch.
- The ship skill records the PR number before the squash.
- `merge-guard` allows exactly what it allows today.

## Why Deferred

The postmortems found it after initiative 0000238 was delivered. No run is active.
