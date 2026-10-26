---
title: "Backlog Entry: 0000181 - phase prefixes appear inconsistently"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000181 - phase prefixes appear inconsistently

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

Replies often lack the `P0 Discovery:` to `P4 Ship:` and `I-A Chart:` to `I-E Delivery:` prefixes. The human on the loop then can't tell which phase or stage a reply belongs to. During roadmap 0000168, the supervising session dropped them after its context was compacted.

The causes:

- Only `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` defines the prefixes. The boot file and the plan, validate, and ship skills don't restate them.
- No hook checks them. The `Stop` hook list in `.claude/settings.json` is empty, so the rule is instruction-only.
- After compaction, the harness truncates the orchestrator skill and marks it as background context. The summary doesn't carry the rule.
- No prefix covers work outside a phase. Examples are supervising an initiative driver, filing backlog entries, and answering questions while another session runs the step.

## Suggested Action

- Put the prefix table and the status form in the boot file, so each session start and each compaction reloads them.
- Restate the prefix in each phase skill's opening lines.
- Define a prefix for out-of-phase work, for example `Supervise:` or `I-C Run:` with a status of `Note`.
- Add a `Stop` hook that warns when a reply in an active run lacks a valid prefix. Start it as a warning, not a block, and log misses so the rate can be measured.

## Wanted outcome

In an active run, every reply starts with a valid prefix, including after compaction and in supervising sessions. A hook test feeds replies with and without a prefix and checks the warning.

## Why Deferred

The human asked for it while roadmap 0000168 step 4 was running.
