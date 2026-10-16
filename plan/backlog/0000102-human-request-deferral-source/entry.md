---
title: "Backlog Entry: 0000102 - add human request as a backlog deferral source"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000102 - add human request as a backlog deferral source

**Source feature:** none (human request)
**Source phase:** none (outside a pipeline run)
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

`planifest-zero/templates/backlog-entry.template.md` allows three deferral sources. All three assume a pipeline run found the item: `discovered mid-flight`, `deliberate scope decision`, and `tech debt`. An idea the human files directly fits none of them. Entries 0000098 to 0000102 already use `human request`, which the template doesn't list.

## Suggested Action

Add `human request` as a fourth deferral source in the template and its guidance. Allow `none (human request)` for the source feature and source phase fields.

## Why Deferred

Found while filing 0000098 to 0000101. It is a template change and needs its own run.
