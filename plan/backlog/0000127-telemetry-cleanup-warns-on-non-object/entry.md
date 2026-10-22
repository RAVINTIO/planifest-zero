---
title: "Backlog Entry: 0000127 - Telemetry cleanup warns on a non-object settings file"
summary: "The setup.sh telemetry cleanup prints a misleading warning before the shape check line when settings.json is null."
status: "open"
---
# Backlog Entry: 0000127 - Telemetry cleanup warns on a non-object settings file

**Source feature:** 0000040-setup-json-checks-and-park
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-21

---

## Problem

`remove_legacy_telemetry_wiring` in `planifest-zero/setup.sh` runs before the hook install step. It reads `s.hooks` with no shape check. If `settings.json` holds `null`, node throws and the step prints `! Warning: could not remove telemetry hook entries from .claude/settings.json`. The hook install step then prints the shape check line from 0000040 ADR-002 and exits 1. The output holds two lines for one fault, and the first one names the wrong cause. No file content leaks, and the file stays unchanged.

## Suggested Action

Make the telemetry cleanup skip in silence when the parsed value is not a settings object. The hook install step then reports the fault on its own. Check whether `setup.ps1` has the same gap.

## Why Deferred

req-001 covers the hook install step only. The extra warning does not change the exit code or the file, so it does not block 0000040.
