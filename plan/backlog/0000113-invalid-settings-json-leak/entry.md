---
title: "Backlog Entry: 0000113 - setup.sh prints settings.json contents on invalid JSON"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000113 - setup.sh prints settings.json contents on invalid JSON

**Source feature:** 0000038-setup-hook-filter-fixes
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-17

---

## Problem

If `.claude/settings.json` holds invalid JSON, the hook wiring step in `planifest-zero/setup.sh` throws from `JSON.parse` with no handler. Node then prints the failing line of the file and a stack trace to stderr, and setup exits 1. A value planted in the file appeared in the output. That breaks the logging policy from 0000033 req-004, which says setup never logs the file's contents.

The behaviour predates 0000038. The file itself stays unchanged.

## Suggested Action

Catch the parse error in the hook wiring step, as the telemetry cleanup step already does. Print one warning that names the file but not its contents, and leave the file unchanged. Check `setup.ps1` for the same gap. Add a planted-value case to both setup suites.

## Why Deferred

It's outside the confirmed 0000038 scope, which covers the hook filter only.
