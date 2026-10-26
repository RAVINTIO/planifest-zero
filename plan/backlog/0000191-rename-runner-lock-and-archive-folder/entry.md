---
title: "Backlog Entry: 0000191 - rename the runner lock and delivery archive folder"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000191 - rename the runner lock and delivery archive folder

**Source feature:** 0000189-name-the-roadmap-initiative
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-26

---

## Problem

Feature 0000189 renamed every name in its design Names table to the `initiative` form. Two names for the charted unit were not in that table, so they still say "roadmap":

- the driver lock file `plan/.roadmap-runner.lock`, in `ravintio-zero/scripts/initiative-run.mjs` and its tests
- the delivery archive folder `plan/_archive/{id}-{slug}-roadmap-{date}/`, which the driver's `delivered()` check and `roadmap-standards.md` both use

## Suggested Action

Rename the lock to `plan/.initiative-runner.lock` and the archive folder to `{id}-{slug}-initiative-{date}`. Add both to the old-name guard in `test-0000189-req-007-old-name-guard.sh`. Existing archive folders keep their names, so the `delivered()` check must accept both forms.

## Why Deferred

The confirmed design listed the names to change, and these two were not on it. Changing the archive folder also touches history matching, which needs its own decision.
