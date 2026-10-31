---
title: "Backlog Entry: 0000310 - add priority, an index, and a staleness review to the backlog"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000310 - add priority, an index, and a staleness review to the backlog

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

On 2026-10-31, the backlog held 55 open entries. The oldest was 0000174.

Entries have no priority or theme. P0 pickup offers every entry one at a time, and nothing lists the backlog in one place. Nothing flags an entry that has sat open for weeks or that a later change made obsolete.

## Suggested Action

- Add `priority` and `theme` fields to the backlog template's frontmatter.
- Generate `plan/backlog/index.md` from the entries, grouped by theme and ordered by priority. Fail CI when it is stale.
- At P0, offer entries by priority and theme rather than one at a time in id order.
- Add a review that lists entries older than a set age and asks whether each still applies.
- Add a migration that sets a default priority and theme on existing entries.

## Wanted outcome

A developer can see the backlog at a glance, and pickup starts with what matters most. Tests check these conditions:

- The index lists every open entry with its priority and theme.
- CI fails when the committed index differs from a fresh run.
- The review lists an entry older than the set age.

## Why Deferred

The human asked for it on 2026-10-31, from a review of the open backlog. No run is active.
