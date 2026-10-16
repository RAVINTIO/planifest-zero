---
title: "Backlog Entry: 0000107 - the enforcement hook merge assumes array event values"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000107 - the enforcement hook merge assumes array event values

**Source feature:** 0000035-powershell-setup-parity
**Source phase:** P6
**Deferral source:** tech debt
**Date filed:** 2026-10-17

---

## Problem

0000035 req-002 made the legacy telemetry cleanup skip a hook event value that isn't an array. The enforcement hook merge in both scripts still assumes `hooks.PreToolUse` and `hooks.UserPromptSubmit` are arrays. In `setup.sh`, `.filter` throws on a hand-edited object or string, and the run fails. In `setup.ps1`, `@(...)` wraps the value and keeps it as an entry.

## Suggested Action

Decide one rule for both scripts, such as warn and replace a non-array value with the Planifest entries. Add a suite case for each script.

## Why Deferred

See the Out of Scope section of 0000035 `scope.md` and the Tech Debt table in its `recommendations.md`.
