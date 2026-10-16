---
title: "Backlog Entry: 0000097 - switch this repo to run its own pipeline on planifest-zero"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000097 - switch this repo to run its own pipeline on planifest-zero

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P9
**Deferral source:** deliberate scope decision
**Date filed:** 2026-10-16

---

## Problem

This repo runs its own pipeline on `planifest-framework/`, a dev-time copy of the older 10-phase framework. The product it ships is `planifest-zero/`. While the old copy stays, these gaps stay open:

- The rename suite fails cases (a) and (b), because `planifest-framework/` exists (merged from 0000086).
- This repo's setup record stays at `planifest-overrides/setup-config/claude-code.md` (merged from 0000089).
- The `validate-telemetry-schema` CI job guards telemetry that the switch removes (merged from 0000093).

## Suggested Action

1. Fix 0000092 first, so that a refresh doesn't replay retired setup flags.
2. Once `planifest-zero/` is stable, run its `setup.sh` on this repo and remove `planifest-framework/`.
3. Confirm `plan/state/claude-code.md` exists and the old setup record is gone.
4. Remove the `validate-telemetry-schema` job from `.github/workflows/planifest.yml`.
5. Confirm the rename suite passes in full.

## Why Deferred

The human wants this repo to use `planifest-zero/` soon, but only once it is stable. See the source entries 0000086, 0000089, and 0000093 for the original reasoning.
