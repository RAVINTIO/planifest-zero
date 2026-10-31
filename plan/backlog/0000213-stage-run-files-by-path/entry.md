---
title: "Backlog Entry: 0000213 - stage run files by path during an initiative"
summary: "A broad git add of plan/ in a step sweeps in backlog entries that the initiative skill queued."
status: "open"
---
# Backlog Entry: 0000213 - stage run files by path during an initiative

**Source feature:** 0000207-codex-support
**Source phase:** P0
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

The orchestrator and ship skills tell a step to commit each artifact, and they name `git add` over whole folders such as `plan/`. While the driver runs, the initiative skill leaves queued backlog entries untracked in `plan/backlog/`. A step that stages `plan/` commits them to its feature branch, so they reach the initiative branch in a step squash and not in the chore step's one commit per entry. The source retrospective is `plan/retrospectives/0000207-codex-support-2026-10-27.md`.

## Suggested Action

Add a rule to the orchestrator and ship skills: during an active initiative, stage artifacts by explicit path (`plan/current/`, `plan/changelog/`, `plan/_archive/`) and never stage `plan/backlog/` entries that the step did not write. Add a test that reads the rule.

## Wanted outcome

A step of an active initiative leaves queued backlog entries untracked, and a test fails if the rule is missing from either skill.

## Why Deferred

It changes two skills and needs its own test and size-budget check.
