---
title: "Backlog Entry: 0000142 - park.mjs follows symlinks in the entry path"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000142 - park.mjs follows symlinks in the entry path

**Source feature:** 0000041-setup-cleanup-and-park-hardening
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-22

---

## Problem

`parkContext` in `planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` checks that the entry path stays under `plan/backlog/` (lines 118-122). The check uses `path.resolve`, which reads the path as text and never follows a symlink.

`finishPr` checks out `chore/park-{feature-id}` from `origin/main` (line 171). If `origin/main` holds a symlink at `plan/backlog` or at the entry folder, the file calls follow it:

- `writeFileSync` (line 173) overwrites `entry.md` in the symlink target. This predates 0000041.
- `git add` then fails with `beyond a symbolic link`. The 0000041 cleanup calls `rmSync` (line 156), which deletes that file outside the repo.

The P4 security review confirmed both in a scratch repo. A planted `outside/0000900-park-demo/entry.md` was overwritten and then deleted. The file name is always `entry.md`, and the attack needs a symlink committed to `main`.

## Suggested Action

Before the write, resolve the entry folder with `fs.realpathSync` and check that it stays under the real `plan/backlog/`. Refuse if any part of the path is a symlink. Apply the same check before `rmSync`.

## Why Deferred

The overwrite predates 0000041, and the fix changes the containment check that 0000040 designed. It needs its own test with a committed symlink.
