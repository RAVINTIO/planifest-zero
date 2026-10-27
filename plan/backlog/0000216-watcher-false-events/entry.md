---
title: "Backlog Entry: 0000216 - the initiative watcher reports false events"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000216 - the initiative watcher reports false events

**Source feature:** none (initiative 0000195 step 13)
**Source phase:** none (initiative session)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

`ravintio-zero/scripts/initiative-watch.mjs` sent the human false or noisy events during initiative 0000195 step 13:

- **Repeated stale warning.** It flagged the log as stale while P3 ran the test suite. The last commit had landed seconds after the last log write. It then repeated the warning on every pass, four times in two minutes.
- **Old commits as new.** When the step merged and the working tree moved to the initiative branch, it reported every commit in the repo history as a new event.
- **Wrong lock state.** Its heartbeat said `lock held` after the driver had released the lock and exited.

The human could not tell real progress from noise, and the initiative session had to stop the watcher.

## Suggested Action

- Report a stale log only when a commit is at least the stale interval newer than the last log write. Report each stale state once, until the log or the commit changes.
- Track seen commits by ancestry, such as `git log {last-seen}..HEAD`. If the last-seen commit isn't an ancestor of `HEAD`, report the branch change in one line, not each commit.
- Read the lock state on each heartbeat, not from an earlier pass.

## Wanted outcome

Tests with `--once` and the test aids check these conditions:

- A commit 5 seconds newer than the log gives no stale line.
- A real stale state gives one stale line across three passes.
- A switch to a branch that holds 100 unseen older commits gives one branch-change line and no commit lines.
- A heartbeat after the lock file is removed reports the lock as free.

## Why Deferred

The human was watching initiative 0000195 step 13 when the watcher misreported. The initiative session filed it after the step merged.
