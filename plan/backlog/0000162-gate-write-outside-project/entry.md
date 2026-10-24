---
title: "Backlog Entry: 0000162 - gate-write blocks writes outside the project"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000162 - gate-write blocks writes outside the project

**Source feature:** 0000160-ravintio-rebrand
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-24

---

## Problem

The `gate-write` hook blocks a Write or Edit to a file outside the project, such as the agent's memory folder under `~/.claude/projects/`. Between runs no `plan/current/design.md` exists, so the hook stops the write with "No confirmed design at plan/current/design.md".

The cause is in `hooks/enforcement/gate-write.mjs`. When the target is not under `cwd`, the hook sets `relTarget` to the raw absolute path. That path fails the always-permitted check, so Check 2, the design check, blocks it. During a run the write fails Check 3 instead, unless a component path happens to match.

The repo `CLAUDE.md` says the hook gates writes to `src/`. In practice it gates every path that is not always permitted, which also differs from that description.

## Suggested Action

Exit 0 when the resolved target sits outside the project root, using the real path so a symlink inside the project cannot escape the check. Add a test for a target outside the project, with and without `design.md`. Then decide whether the hook should gate only `src/`, as `CLAUDE.md` says, or every path, and make the docs match.

## Why Deferred

Found at ship of 0000160, after its PR was ready for review. The fix changes hook behaviour, so it needs its own requirement and tests.
