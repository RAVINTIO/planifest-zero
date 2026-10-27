---
title: "Backlog Entry: 0000223 - chart flags an entry that widens a guard"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000223 - chart flags an entry that widens a guard

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

At chart for initiative 0000195 on 2026-10-26, the human asked for a **Wanted outcome** in entry 0000190. The first draft widened the fix to skip heredoc bodies in `merge-guard`. That change would have weakened a fail-closed guard. The guard's shell blocklist misses these forms:

- `python3 -c`
- `xargs`
- `find -exec`

A heredoc body could carry any of them past the guard. The human caught the widening in review. Chart then cut 0000190 back to a message-only fix (commit `f2df492`).

No chart rule asks whether an entry widens what a guard lets through. The I-A Chart section of `ravintio-zero/standards/roadmap-standards.md` and the `ravintio-initiative` skill have no such check. The retrospective lists it under **Chart** and in its Actions table.

## Suggested Action

Add a chart rule that checks each entry against the guards. A guard is `merge-guard`, `gate-write`, `ratchet-check`, or any other fail-closed hook. If an entry widens what a guard lets through, chart says so plainly. It names the guard and the new forms it would allow, and asks the human to approve the widening on its own. The rule lives in the I-A Chart section of `roadmap-standards.md` and in `ravintio-zero/skills/ravintio-initiative/SKILL.md`.

This change adds a chart rule only. It must not change any hook's behaviour.

## Wanted outcome

- A test reads the guard-widening rule in the I-A Chart section of `roadmap-standards.md`.
- The rule names `merge-guard`, `gate-write`, and `ratchet-check`, and covers any other fail-closed hook.
- The rule needs a separate human approval for each widening entry, apart from the chart approval.
- Every hook suite in `ravintio-zero/tests/` passes unchanged, and no file under the hooks folder changes.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. The initiative had already delivered, so no step could take it in.
