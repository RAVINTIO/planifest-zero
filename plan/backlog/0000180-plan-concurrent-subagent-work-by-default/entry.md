---
title: "Backlog Entry: 0000180 - plan concurrent subagent work by default"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000180 - plan concurrent subagent work by default

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

Plans default to single-threaded work, which is slower. The dispatch standard (`ravintio-zero/standards/agent-dispatch-standards.md`) names units that may run in parallel. But the plan for a run doesn't lay out which work can run concurrently and when. So the orchestrator decides batch by batch and often ends up working in sequence.

The human on the loop raised this during RAVINTIO Framework feature 0000039-ravintio-rebrand. In that run, a late change ran mostly as a chain: test-writer, implementer, refactor, CI, security re-review, then fix. The human had to ask "Can you use subagents to accelerate?" before independent work moved into one batch. Framework backlog 0000267 holds the same entry.

## Suggested Action

Make the plan, and any re-plan after a reopened phase, include a concurrency plan. It lists the work units, their dependencies, and the batches that can run at once when they share no files. Default to concurrent dispatch when two units have no dependency and no shared write target, and record the reason when work runs in sequence.

## Wanted outcome

Every execution plan has a concurrency section that lists the units, their dependencies, and the batches. Each unit that runs in sequence gives its reason. The consistency check fails a plan that lacks the section.

## Why Deferred

The human on the loop asked for it as a backlog entry. Feature 0000172-subagent-acceleration, which was in progress when this entry was filed, adds a `fast` run speed with batched dispatch per phase. Check at pickup what 0000172 already covers. This entry asks for more: concurrency planned up front and the default for every run, not just one speed setting.
