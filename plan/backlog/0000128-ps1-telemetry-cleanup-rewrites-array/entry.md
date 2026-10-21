---
title: "Backlog Entry: 0000128 - setup.ps1 telemetry cleanup rewrites a top-level array"
summary: "Remove-LegacyTelemetryWiring in setup.ps1 can rewrite a one-item top-level array as an object before the shape check runs."
status: "open"
---
# Backlog Entry: 0000128 - setup.ps1 telemetry cleanup rewrites a top-level array

**Source feature:** 0000040-setup-json-checks-and-park
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-21

---

## Problem

`Remove-LegacyTelemetryWiring` in `planifest-zero/setup.ps1` runs before `Install-EnforcementHooks`. It parses `settings.json` with `ConvertFrom-Json` and has no shape check.

Take a file that holds a one-item top-level array, such as `[{"hooks":{"Stop":[...telemetry entry...]}}]`:

- PowerShell 7 unrolls the array into its object.
- Windows PowerShell 5.1 keeps the array, but member access reads through it to the object.

Either way, the step removes the telemetry entry. It then writes `$existing | ConvertTo-Json`, and the pipeline unrolls the array. The file becomes a top-level object. The 0000040 req-002 shape check then sees an object and passes, so setup exits 0. The user's array is gone.

This finding comes from reading the code. Nobody has run it, because no PowerShell host was available.

## Suggested Action

Give the telemetry cleanup the same shape test as `Merge-EnforcementHookSettings`. If the first character is not `{`, or the parsed value is not a `PSCustomObject`, skip the step without a write. Add a test with the input above. Fold in 0000127, which reports the matching warning gap in `setup.sh`.

## Why Deferred

0000040 req-002 covers the hook install step only. This input needs a planted telemetry entry inside an array, which is rare. The fix belongs with 0000127 and the retirement of the legacy cleanup (0000095).
