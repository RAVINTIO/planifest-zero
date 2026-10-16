---
title: "Backlog Entry: 0000093 - the CI telemetry schema job loses its subject after the framework refresh"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000093 - the CI telemetry schema job loses its subject after the framework refresh

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P6
**Deferral source:** deliberate scope decision

**Date filed:** 2026-10-16

---

## Problem

The `validate-telemetry-schema` job in `.github/workflows/planifest.yml` guards the telemetry in `planifest-framework/`. The next refresh of that copy carries this feature's telemetry removal into it. The job then has nothing to validate. Backlog 0000089 covers the refresh but not the CI job.

## Suggested Action

Remove the `validate-telemetry-schema` job in the same change that refreshes `planifest-framework/`.

## Why Deferred

See the Deferred Items row in this feature's `recommendations.md`. `planifest-framework/` is out of scope for 0000033, per ADR-001.
