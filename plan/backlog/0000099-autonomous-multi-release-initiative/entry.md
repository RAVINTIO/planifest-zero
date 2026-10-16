---
title: "Backlog Entry: 0000099 - run a multi-release initiative autonomously across cleared sessions"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000099 - run a multi-release initiative autonomously across cleared sessions

**Source feature:** none (human request)
**Source phase:** none (outside a pipeline run)
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

A pipeline run delivers one feature. Waves split a large feature, but each wave needs a human to start it in a new session. No construct tracks an initiative that delivers a series of related features over several releases. Nothing carries it from start to end across cleared sessions without a human restarting each step.

## Suggested Action

Add an initiative record, likely under the roadmap area from 0000098. It lists the ordered features, the current position, and the stop conditions. At the end of each P9, or at session start, the orchestrator resumes the initiative and starts the next feature. It keeps the existing human gates: the human still merges every PR.

## Why Deferred

The human raised it as a new capability. It depends on 0000098 and needs a design for session hand-off and for when the run must stop and ask.
