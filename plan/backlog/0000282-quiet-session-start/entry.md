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

Migration state also lives in the wrong place. The migrator records a finished migration by moving its file into `ravintio-zero/migrations/_done/` (`ravintio-migrator/SKILL.md:52`). That folder sits inside the pack, which causes two problems:

- A pack update replaces `ravintio-zero/`, and the new pack ships each migration as pending again. A consumer who already ran one sees it as pending once more.
- The migrator edits the pack folder. Entry 0000299 makes setup refuse uncommitted changes there, so an uncommitted archive move would block setup.

## Suggested Action

- When a migration's `Applies when:` condition is false, record that result once, for example in `plan/state/migrations.md`, with the pack version that checked it.
- Report the migration again only when the pack version changes or the condition becomes true.
- Record finished migrations in the same file, outside the pack, rather than moving their files into `ravintio-zero/migrations/_done/`. Each row names the migration, its result (`done` or `not applicable`), and the pack version.
- Make `resume-detect.mjs` and the migrator read that file, so a pack update doesn't bring back a migration that already ran.
- Add a migration that copies existing `_done/` records into the file.
- Apply the same rule to any other finding that has no action: report it once, then stay quiet until something changes.

## Wanted outcome

Session-start findings list only items that need action now. Tests check these conditions:

- A migration whose condition is false appears once, and not on later sessions with the same pack version.
- The migration appears again after a pack update.
- A migration whose condition becomes true appears at once.
- A migration recorded as `done` stays quiet after a pack update that ships it as pending.
- Running a migration leaves no change inside `ravintio-zero/`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
