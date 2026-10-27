---
title: "Backlog Entry: 0000231 - subagents in a parallel batch never stash"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000231 - subagents in a parallel batch never stash

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

In initiative 0000195 step 5 (0000200), a P2 subagent ran `git stash` to get a baseline. The subagents in that batch shared one working tree. The stash took the other subagents' uncommitted edits. The parent restored them with `git stash pop`, and no work was lost. Three records note it:

- `plan/_archive/0000200-reply-conventions-2026-10-27/build-log.md`, the `Subagent incident` line.
- `plan/_archive/0000200-reply-conventions-2026-10-27/build-report.md`, item 2. It names the gap: the brief did not forbid git state changes.
- `plan/.initiative-logs/step-5.log`, the process faults line.

`ravintio-zero/standards/agent-dispatch-standards.md` has no rule against it. Its `## Fast batches` section says units share one working tree and stage by path. It says nothing about `git stash`, `git checkout`, or `git reset`. The Agent Dispatch Template prompts also leave git state out. The standard does tell the parent to stash on resume, under `### Resuming an interrupted unit`. That stash runs with no unit active, so it is safe.

## Suggested Action

Add a rule to `ravintio-zero/standards/agent-dispatch-standards.md` that forbids `git stash` in a subagent during a parallel batch. Give the reason: a stash in one subagent takes the uncommitted work of every other subagent. Add one line to the dispatch skeleton prompts that says the same. Keep the parent's resume stash as it is.

## Wanted outcome

A test checks these conditions:

- `agent-dispatch-standards.md` forbids `git stash` in a subagent during a parallel batch.
- The rule states that a stash takes the other subagents' uncommitted work.
- Each prompt in the parallel dispatch skeleton forbids `git stash`.
- The `### Resuming an interrupted unit` section still tells the parent to stash.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`.
