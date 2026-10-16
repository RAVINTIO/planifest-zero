---
title: "Backlog Entry: 0000094 - setup.ps1 wraps a non-array hook event value in an array"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000094 - setup.ps1 wraps a non-array hook event value in an array

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P6
**Deferral source:** tech debt

**Date filed:** 2026-10-16

---

## Problem

When `Remove-LegacyTelemetryWiring` in `setup.ps1` rewrites `.claude/settings.json`, it wraps a non-array hook event value in an array. `remove_legacy_telemetry_wiring` in `setup.sh` leaves that value alone. The rewrite happens only when the cleanup removes something.

## Suggested Action

Make `setup.ps1` skip a non-array event value, as `setup.sh` does. Add a PowerShell test once a `pwsh` runner exists (backlog 0000084).

## Why Deferred

See the Tech Debt row in this feature's `recommendations.md` and the parity section of its `security-report.md`.
