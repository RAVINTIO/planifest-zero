---
title: "Backlog Entry: 0000111 - UserPromptSubmit filter parity"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000111 - UserPromptSubmit filter parity

**Source feature:** 0000037-self-host-on-planifest-zero
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-17

---

## Problem

`planifest-zero/setup.sh` matches Planifest `UserPromptSubmit` entries by substring, for example `includes("check-design")`. `planifest-zero/setup.ps1` uses the case-sensitive path-boundary regex from 0000035 S-004. So the two scripts can remove different entries from the same `settings.json`. A user hook whose path contains `check-design` would be removed by `setup.sh` but kept by `setup.ps1`.

## Suggested Action

Make `setup.sh` match `UserPromptSubmit` entries with the same path-boundary rule as `setup.ps1`. Add a planted-entry case to the hook parity suite.

## Why Deferred

req-007 in 0000037 aligns only the `PreToolUse` filter. This gap is separate, and the run's scope is already confirmed.
