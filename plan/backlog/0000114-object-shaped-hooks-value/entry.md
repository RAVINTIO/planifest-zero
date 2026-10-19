---
title: "Backlog Entry: 0000114 - an object-shaped hooks value keeps a stale Planifest command"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000114 - an object-shaped hooks value keeps a stale Planifest command

**Source feature:** 0000038-setup-hook-filter-fixes
**Source phase:** P4 (security finding F-001, Low)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-17

---

## Problem

If an entry's `hooks` value is one object instead of an array, both setup scripts keep the entry as it was (0000038 ADR-002). If that object runs a Planifest module, the stale command stays beside the fresh entry, so the hook runs twice. Before 0000038, `setup.sh` failed on this shape and `setup.ps1` removed the entry.

## Suggested Action

Treat an object-shaped `hooks` value as a one-item array in both scripts, then apply the per-command filter. Update the single-object case in both 0000038 suites.

## Why Deferred

The confirmed 0000038 design keeps a non-array `hooks` value as it was. The shape is rare, and both scripts now behave the same.
