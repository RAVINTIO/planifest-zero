---
title: "Backlog Entry: 0000103 - assume standard-iterative mode instead of asking"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000103 - assume standard-iterative mode instead of asking

**Source feature:** 0000034-setup-hardening
**Source phase:** P0
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

At P0 the orchestrator detects the adoption mode, then asks the human to confirm it. In a repo with prior runs in `plan/_archive/` and a `docs/about.md`, the answer is always standard-iterative. The question adds a round trip to every run and tells the human nothing new.

## Suggested Action

When standard-iterative is the only signal present, have the orchestrator assume it and state it in the P0 briefing without asking. Keep the question when signals conflict, or when the mode is external anchor, retrofit, or greenfield. Record the assumed mode in `discovery.md` and the build log as before.

## Why Deferred

The human asked for it during 0000034 P0. It changes the orchestrator's P0 steps, which is outside 0000034's setup-hardening scope.
