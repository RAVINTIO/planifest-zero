---
title: "Backlog Entry: 0000288 - hooks resolve from the project root and fail closed"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000288 - hooks resolve from the project root and fail closed

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Setup wires every hook with a path relative to the working directory (`setup.sh` `install_enforcement_hooks`, called at line 1050). `.claude/settings.json` then holds commands such as `node ".claude/hooks/enforcement/gate-write.mjs"`.

When the working directory leaves the project root, each hook command fails with `MODULE_NOT_FOUND`. Node exits 1, and Claude Code treats exit 1 as a non-blocking error. The fail-closed guards then enforce nothing. Those guards are `gate-write`, `merge-guard`, `ratchet-check`, and `em-dash-guard`.

On 2026-10-31, an agent's `cd` into `ravintio-zero/` caused exactly this failure. Entry 0000287 returns Bash to the project root after each command. This entry covers the remaining ways the working directory can move, such as a subagent or a future harness change, and makes a missing hook visible.

## Suggested Action

- Wire each hook as `node "$CLAUDE_PROJECT_DIR/.claude/hooks/enforcement/{hook}.mjs"`, so the path doesn't depend on the working directory. Do the same for the Codex adapter.
- Add a small launcher that every PreToolUse guard runs through. If the hook script is missing or can't load, the launcher exits 2 with a message that names the script. This makes the guards stricter. It must not let anything pass that a guard blocks today.
- Keep advisory hooks, such as `check-reply-prefix`, non-blocking, but have them report a missing script once.
- At pickup, confirm the name and scope of `CLAUDE_PROJECT_DIR` in the Claude Code hooks documentation.

## Wanted outcome

Every hook runs from any working directory, and a guard that can't run blocks rather than allows. Tests check these conditions:

- Each hook command in `.claude/settings.json` runs and resolves when started from a subfolder of the project.
- A guard whose script is missing exits 2 and names the script.
- Every case that a guard blocks today stays blocked.

## Why Deferred

The human asked for it on 2026-10-31, after the hook failure that entry 0000287 records. No run is active.
