---
title: "Backlog Entry: 0000098 - add a roadmap area to plan for long-term plans"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000098 - add a roadmap area to plan for long-term plans

**Source feature:** none (human request)
**Source phase:** none (outside a pipeline run)
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

`plan/` has no place for long-term intent. The backlog holds discrete, deferred items. `plan/current/` holds one run. Direction that spans several releases has no home, so each P0 starts without it.

## Suggested Action

Add `plan/roadmap/` with a template for a roadmap item: goal, horizon, and the backlog entries or features that deliver it. Have the orchestrator read it at P0 and when it suggests the next release.

## Why Deferred

The human raised it as a new capability. It needs its own design and isn't part of any active feature.
