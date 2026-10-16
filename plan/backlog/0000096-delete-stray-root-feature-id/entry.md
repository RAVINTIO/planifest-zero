---
title: "Backlog Entry: 0000096 - delete the stray .feature-id at the repo root"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000096 - delete the stray .feature-id at the repo root

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P9
**Deferral source:** discovered mid-flight

**Date filed:** 2026-10-16

---

## Problem

The repo root holds a `.feature-id` file that reads `0000031-five-phase-planifest-zero`. Feature
0000031 created it in PR #2 (`dede5dd`), and no process has written it since. The ship skill writes
its marker to `plan/current/.feature-id`, which moves into the archive at P7.

The orchestrator's resume check flags any `.feature-id` whose contents differ from the current work.
The root file never matches a new feature, so every run raises the same false alarm.

## Suggested Action

Delete `.feature-id` from the repo root. Then confirm the next P0 resume check raises no stale-marker
flag.

## Why Deferred

Found after 0000033 shipped as PR #6. The human chose to pick it up in the next release.
