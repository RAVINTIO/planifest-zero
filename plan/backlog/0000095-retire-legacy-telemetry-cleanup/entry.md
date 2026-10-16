---
title: "Backlog Entry: 0000095 - the legacy telemetry cleanup runs on every setup run with no end date"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000095 - the legacy telemetry cleanup runs on every setup run with no end date

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P6
**Deferral source:** tech debt

**Date filed:** 2026-10-16

---

## Problem

The legacy telemetry cleanup from ADR-002 runs on every setup invocation. Once no project carries telemetry wiring, it is dead code that still runs each time.

## Suggested Action

Choose a retirement point, such as a later major version, and delete both cleanup functions and their tests then.

## Why Deferred

See ADR-002's Negative Consequences and the Tech Debt row in this feature's `recommendations.md`.
