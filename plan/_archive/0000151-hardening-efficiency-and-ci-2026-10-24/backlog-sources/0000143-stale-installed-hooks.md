---
title: "Backlog Entry: 0000143 - setup leaves installed hooks that have no source"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000143 - setup leaves installed hooks that have no source

**Source feature:** 0000042-autonomous-mode-and-prefixes
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-23

---

## Problem

`.claude/hooks/enforcement/` holds three files with no source in `planifest-zero/hooks/enforcement/`:

- `check-telemetry-failures.mjs`
- `check-telemetry-receipts.mjs`
- `phase-enum.mjs`

Setup copies hooks in but never removes ones that left the source. They may be leftovers from the telemetry removal in 0000033. `check-telemetry-receipts.mjs` still matches a P1 to P5 phase pattern.

## Suggested Action

Have setup remove installed hooks that no longer exist in the source, or delete these three once. Check that no `settings.json` entry still points at them.

## Why Deferred

It is setup cleanup, not part of the run-mode, phase, or wording change.
