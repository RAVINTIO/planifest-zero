---
title: "Backlog Entry: 0000282 - report each session-start finding only while it needs action"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000282 - report each session-start finding only while it needs action

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`resume-detect.mjs` repeats findings that need no action:

- Migrations 0004 and 0005 appear as "pending migration" in every resume finding, on every prompt. Their `Applies when:` conditions are false in this repo and in `ravintio/docs`, so they stay pending forever. The `ravintio/docs` build logs record the skip in both Zero runs (`0000005` build-log line 40, `0000009` build-log line 40).
- The pack-version check fires on every session in a consumer repo. Entry 0000272 covers that check.

A finding that repeats on every prompt trains the reader to ignore all findings, including real ones.

## Suggested Action

- When a migration's `Applies when:` condition is false, record that result once, for example in `plan/state/migrations.md`, with the pack version that checked it.
- Report the migration again only when the pack version changes or the condition becomes true.
- Apply the same rule to any other finding that has no action: report it once, then stay quiet until something changes.

## Wanted outcome

Session-start findings list only items that need action now. Tests check these conditions:

- A migration whose condition is false appears once, and not on later sessions with the same pack version.
- The migration appears again after a pack update.
- A migration whose condition becomes true appears at once.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
