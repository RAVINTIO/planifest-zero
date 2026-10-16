---
title: "Backlog Entry: 0000106 - setup.sh keeps a Write|Edit gate-write entry an older setup.ps1 wrote"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000106 - setup.sh keeps a Write|Edit gate-write entry an older setup.ps1 wrote

**Source feature:** 0000035-powershell-setup-parity
**Source phase:** P6
**Deferral source:** deliberate scope decision
**Date filed:** 2026-10-17

---

## Problem

Before 0000035, `setup.ps1` wired `gate-write` as one `PreToolUse` entry with matcher `Write|Edit`. The `PreToolUse` filter in `setup.sh` removes only entries whose matcher is `Write` or `Edit`. If you run `setup.sh` on a project that an older `setup.ps1` set up, the old entry stays and `gate-write` runs twice on each write.

## Suggested Action

Make the `setup.sh` filter match by module name on any matcher, as `setup.ps1` now does. Add a case to `test-0000035-req-001-hook-parity.sh` that plants a `Write|Edit` entry and re-runs `setup.sh`.

## Why Deferred

See the Out of Scope section of 0000035 `scope.md`. The duplicate is harmless, because `gate-write` gives the same answer twice.
