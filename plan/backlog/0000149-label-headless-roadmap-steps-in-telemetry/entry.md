---
title: "Backlog Entry: 0000149 - Label headless roadmap steps in telemetry"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000149 - Label headless roadmap steps in telemetry

**Source feature:** rapid-prototypes 0000008-claude-usage-observability (usage analysis)
**Source phase:** P4
**Deferral source:** human request
**Date filed:** 2026-10-24

---

## Problem

The human's Claude Code telemetry can't say which roadmap step spent what. `planifest-zero/scripts/roadmap-run.mjs` starts each step as a fresh `claude -p` session (lines 135 to 145). Each step's records carry a session ID, but nothing names the roadmap or the step.

The acceptance clone `pz-roadmap-acceptance-0000043` shows the gap. From 2026-10-12 to 2026-10-24, headless (`sdk`) sessions there made 389 requests in 8 sessions, for an API-equivalent $23.39. To find out which step cost what, you have to match session start times to the driver's output by hand.

Claude Code copies `OTEL_RESOURCE_ATTRIBUTES` onto every record a session sends. A test on 2026-10-24 started `claude -p` with `work.kind=tag-test,work.item=probe-1`. Every record in the store carried both fields, `api_request` included.

## Suggested Action

In `runStep`, pass an `env` to `spawn` that adds roadmap labels to any `OTEL_RESOURCE_ATTRIBUTES` already set. For example: `work.kind=roadmap,planifest.roadmap={id}-{slug},planifest.step={position}`. Append to an existing value and never replace it. Percent-encode any value that could contain a comma, an equals sign, or a space, as the OpenTelemetry specification requires. Add a test that checks the spawned environment holds the labels and keeps the existing value.

The labels hold identifiers only, never prompt or file content. If no telemetry is set up, the variable has no effect.

## Why Deferred

The analysis ran in rapid-prototypes during its feature `0000008`. The change belongs to this repo's roadmap driver, so it needs its own run here. It is related to `0000148`, which covers the model and turn limits for the same `claude -p` call.
