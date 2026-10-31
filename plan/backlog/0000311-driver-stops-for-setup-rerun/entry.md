---
title: "Backlog Entry: 0000311 - the driver stops for a setup rerun between steps"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000311 - the driver stops for a setup rerun between steps

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Step sessions load the installed copies of the pack in `.claude/`, which setup writes. When a step changes a skill, a hook, or `setup.sh`, later steps still run the old installed copies until someone reruns setup.

The driver can't pause for that rerun. It stops between steps in one case only: a step changed `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill (`initiative-run.mjs:117-121` and `504-507`). It has no charted stop.

Initiative 0000238 worked around this with a final chore step that refreshed setup (step 15, 0000253). Steps 1 to 14 ran on installed copies from before the initiative, and `test-0000151-req-014` failed in each step because the copies lagged the pack.

Setup writes only ignored files, `.claude/` and `CLAUDE.md` (`.gitignore` lines 2 and 3). A rerun therefore needs a pause, not a step or a commit.

## Suggested Action

- Have the driver also watch the files that setup installs, such as `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, and `ravintio-zero/setup/`.
- After a merged step changes any of them, print `I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.`, release the lock, and exit 1.
- In the initiative skill, treat a `Setup:` line as a planned stop, not a failure:
  1. Read the setup command from the initiative's `Confirmation:` row, such as the command that `custom-006` approves.
  2. Run that exact command. If no row names it, stop and ask the human.
  3. Check that every hook in `.claude/settings.json` resolves and runs. If one fails, stop and report it.
  4. Start a new driver and watcher.
- Keep the `Restart:` stop. If a step triggers both, print one line that names both.
- Document the stop in the roadmap standards.

## Wanted outcome

Every step runs on installed copies that match the pack at its start. Tests check these conditions:

- A step that changes a file under `ravintio-zero/skills/` makes the driver print a `Setup:` line and exit 1.
- A step that changes only tests makes no `Setup:` line.
- The initiative skill names the `Setup:` stop, the command source, and the hook check.

## Why Deferred

The human asked for it on 2026-10-31, while ordering the next initiative. No run is active.
