---
title: "Backlog Entry: 0000104 - setup doesn't ignore a leftover settings.json.planifest-tmp"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000104 - setup doesn't ignore a leftover settings.json.planifest-tmp

**Source feature:** 0000034-setup-hardening
**Source phase:** P6
**Deferral source:** tech debt
**Date filed:** 2026-10-16

---

## Problem

A hard stop between the temporary write and the rename leaves `.claude/settings.json.planifest-tmp` behind. The next run replaces it. A project that doesn't ignore `.claude/` could commit it in the meantime (0000034 security report S-009).

## Suggested Action

Have setup add `settings.json.planifest-tmp` to the ignore rules it writes, or remove a leftover at the start of every run.

## Why Deferred

See the Tech Debt table in 0000034 `recommendations.md`. The P5 review rated it Low.
