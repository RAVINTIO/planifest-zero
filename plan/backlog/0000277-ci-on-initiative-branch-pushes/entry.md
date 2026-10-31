---
title: "Backlog Entry: 0000277 - run CI on every push to an initiative branch"
summary: "A postmortem action, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000277 - run CI on every push to an initiative branch

**Source feature:** none (initiative 0000238 postmortems)
**Source phase:** none (human request)
**Deferral source:** postmortem `plan/postmortems/2026-10-31-step-4-content-test-failed-on-coordinator-entry.md`
**Date filed:** 2026-10-31

---

## Problem

`.github/workflows/ravintio.yml` runs on pull requests into `initiative/**`, but its `push` trigger lists only `main` and `master`. A commit pushed directly to an initiative branch runs no CI.

In initiative 0000238, the coordinator pushed entry 0000257 directly in `05abbb9`. It broke `test-0000042-req-010`, and nothing flagged it until step 4 ran the suite about five hours later.

Entry 0000274 routes coordinator work through PRs. This entry finds any direct commit that still lands.

## Suggested Action

- Add `'initiative/**'` to the `push` trigger in `ravintio.yml`.
- Keep the `release-tag` job on `main` and `master` only. It runs on `push` events today, so a broader trigger would run it on initiative pushes.
- Have the driver or the initiative skill report a failed CI run on the initiative branch before the next step starts.

## Wanted outcome

A direct push to an initiative branch runs the full suite. Tests check these conditions:

- The `push` trigger in `ravintio.yml` includes `initiative/**`.
- The `release-tag` job runs only on `main` and `master`.

## Why Deferred

The postmortem found it after initiative 0000238 was delivered. No run is active.
