---
title: "Backlog Entry: 0000091 - settings.json rewrites are not atomic, and bash skips cleanup silently without node"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000091 - settings.json rewrites are not atomic, and bash skips cleanup silently without node

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P5
**Deferral source:** discovered mid-flight

**Date filed:** 2026-10-16

---

## Problem

Both setup scripts write `.claude/settings.json` in place. `setup.sh` uses `fs.writeFileSync` and
`setup.ps1` uses `Set-Content`. If a write stops partway, for example on a full disk, the file can be
left truncated. The legacy telemetry cleanup and every existing installer write the same way.

`remove_legacy_telemetry_wiring` in `setup.sh` also skips the settings cleanup when `node` is not on
the `PATH`. It prints no warning, so the stale entries stay with no stated cause.

## Suggested Action

1. Write `settings.json` to a temporary file in the same directory, then rename it over the original,
   in both scripts and every installer that writes the file.
2. Have `setup.sh` print one warning when `node` is missing and the settings cleanup is skipped.

## Why Deferred

The non-atomic write predates feature 0000033 and affects every installer, not only the cleanup. The
P5 review rated both items Low.
