---
title: "Scope - watcher false events"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - watcher false events

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Version:** 0.31.1

## In Scope

- Stale line needs a commit at least `STALE_MS` newer than the last log write.
- Each stale state prints once until the log or the commit changes.
- A branch switch prints one line. Ordinary new commits come from `git log {last-seen}..HEAD`.
- A lock-state test, and a fix if the test fails.
- `--passes <n>` test aid, tests, watcher header comment, and roadmap standards text.

## Out of Scope

- Driver, skill, and hook changes.
- New event kinds.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.

## Deferred

- Nothing deferred.
