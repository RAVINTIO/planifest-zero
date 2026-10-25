---
title: "Backlog Entry: 0000100 - add quality and governance gates that evaluate agent workflows"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000100 - add quality and governance gates that evaluate agent workflows

**Source feature:** none (human request)
**Source phase:** none (outside a pipeline run)
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

The pipeline checks the product it builds, through tests, security review, and the consistency check. Nothing measures how well the workflow itself performed. Examples include rework loops, gate overrides, deviations from the design, and how often the human corrected the agent. Without a measure, changes to the skills can't show they improved quality.

## Suggested Action

Define a small set of workflow quality metrics and derive them from artifacts the pipeline already writes, such as the build log and iteration log. Add a governance gate that compares a run against thresholds and reports or blocks. Include an evaluation suite that runs the skills against fixed briefs, so a skill change can show a before-and-after score.

## Wanted outcome

At ship, a script derives four workflow metrics from the build log and iteration logs:

- rework loops per requirement
- `Blocked:` stops
- mid-pipeline design changes
- human corrections at gates

The governance gate compares each metric against a threshold in the pack. It reports any breach in the build assessment and the PR description. It does not block.

The evaluation suite that runs the skills against fixed briefs is out of scope. Backlog entry 0000174 holds it.

## Why Deferred

The human raised it as a new capability. It needs decisions on which metrics count and whether the gate reports or blocks.
