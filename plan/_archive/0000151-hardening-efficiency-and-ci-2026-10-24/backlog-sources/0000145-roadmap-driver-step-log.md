---
title: "Backlog Entry: 0000145 - Roadmap driver keeps no per-step output log"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000145 - Roadmap driver keeps no per-step output log

**Source feature:** 0000043-autonomous-roadmaps
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-24

---

## Problem

`planifest-zero/scripts/roadmap-run.mjs` discards the stdout of each child `claude -p` session. When a step blocks, the build log is the only record for diagnosis. A failed `claude` call, a stalled position, or a permission prompt leaves no trace of what the child session did.

## Suggested Action

Write each child session's output to a gitignored log per step, such as `plan/.roadmap-logs/step-{position}.log`. Name that path in the driver's stop line so the human knows where to look.

## Why Deferred

The driver meets every 0000043 requirement without a log. Adding one changes the driver's output contract and the gitignore rules, so it needs its own design decision.
