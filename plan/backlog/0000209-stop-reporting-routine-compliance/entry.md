---
title: "Backlog Entry: 0000209 - stop reporting routine compliance in replies"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000209 - stop reporting routine compliance in replies

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-26

---

## Problem

Replies tell the human that the agent followed a standing rule, when following it is routine. For example, after raising PR #38, the agent reported that it had left the session link out of the PR description. The project rules forbid AI attribution, so leaving it out is the expected behaviour and needs no comment. These lines add noise and hide the parts of a reply that need the human's attention.

## Suggested Action

Add a reporting rule to the boot file and the orchestrator skill. A reply reports only results, deviations, failures, and decisions that the human must make. It doesn't report compliance with a standing rule, unless the rule blocked something or the agent departed from it.

## Wanted outcome

Replies never state that the agent followed a standing rule, unless that rule blocked an action or the agent departed from it. A reply that says "I left out the attribution" or "I didn't commit to `main`" after routine work counts as a failure.

## Why Deferred

No run is active. The human asked for the entry on its own, after the PR #38 reply. Initiative draft 0000195 can pull it in at chart.
