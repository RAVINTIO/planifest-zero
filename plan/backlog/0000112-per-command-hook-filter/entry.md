---
title: "Backlog Entry: 0000112 - per-command hook filter"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000112 - per-command hook filter

**Source feature:** 0000037-self-host-on-planifest-zero
**Source phase:** P5 (security finding S-001, Low)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-17

---

## Problem

The `PreToolUse` filter in `planifest-zero/setup.sh` and `planifest-zero/setup.ps1` drops a whole hook entry when any one of its commands names a Planifest module. A user command that shares that entry is lost with no warning. Since 0000037 req-007, `setup.sh` does this on any matcher. A user script with the same basename, such as `/home/u/tools/gate-write.mjs`, is also dropped.

## Suggested Action

Filter one command at a time. Remove only the Planifest commands, and keep the entry if a user command remains. Add a planted-entry case to both setup suites.

## Why Deferred

The finding is Low, and the run's scope is confirmed. The fix changes the merge rule in both scripts and needs its own parity cases.
