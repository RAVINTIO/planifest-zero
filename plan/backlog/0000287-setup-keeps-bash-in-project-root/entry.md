---
title: "Backlog Entry: 0000287 - setup keeps Bash in the project root"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000287 - setup keeps Bash in the project root

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

In Claude Code, a `cd` in one Bash command changes the working directory for every later command and every hook. The RAVINTIO hooks are wired with relative paths, such as `node ".claude/hooks/enforcement/gate-write.mjs"`, so they resolve from that directory.

On 2026-10-31, an agent in this repo ran `cd /Users/martinmayer/d/ravintio/zero/ravintio-zero && sed …` to read `setup.sh`. The working directory stayed in `ravintio-zero/`. The next Stop hook failed with:

```
Error: Cannot find module '/Users/martinmayer/d/ravintio/zero/ravintio-zero/.claude/hooks/enforcement/check-reply-prefix.mjs'
```

`gate-write`, `merge-guard`, `ratchet-check`, and `em-dash-guard` use the same relative paths. A missing script exits 1, which Claude Code treats as a non-blocking error. Until the agent ran `cd` back to the root, those guards enforced nothing. The same happened earlier in initiative 0000238, after a `cd` into `ravintio-overrides`.

## Suggested Action

- Make setup write `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` under `env` in `.claude/settings.json`. Claude Code then returns to the project root after each Bash command, so a `cd` lasts only for its own command.
- Merge the setting into existing `env` values and never overwrite the developer's other entries.
- Write it on every install and on every setup re-run.
- At pickup, confirm the setting's name and behaviour in the Claude Code settings documentation.

## Wanted outcome

A `cd` in one Bash command never changes where later commands or hooks run. Tests check these conditions:

- After setup, `.claude/settings.json` has `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` set to `1` under `env`.
- Setup keeps any other `env` entries that were already there.
- A setup re-run leaves exactly one copy of the setting.

## Why Deferred

The human asked for it on 2026-10-31, after the hook failure above. No run is active.
