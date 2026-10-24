---
title: "Backlog Entry: 0000146 - Hooks write block reasons to stdout"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000146 - Hooks write block reasons to stdout

**Source feature:** 0000043-autonomous-roadmaps
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-24

---

## Problem

Claude Code shows the agent only stderr when a PreToolUse hook exits 2. `gate-write.mjs`, `em-dash-guard.mjs`, and `check-orchestrator-presence.mjs` write their block reasons to stdout. The agent then sees "No stderr output" and no reason. In 0000043, subagents blocked this way wrote files through Bash instead of fixing the cause.

## Suggested Action

Write each block reason to stderr, as `merge-guard.mjs` now does, and keep stdout for any test that reads it. Add one test per hook that reads stderr on a block.

## Why Deferred

0000043 fixed only its new hook. The other hooks belong to earlier features and their tests.
