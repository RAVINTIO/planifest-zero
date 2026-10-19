---
title: "Backlog Entry: 0000118 - setup allowedTools invalid JSON"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000118 - setup allowedTools invalid JSON

**Source feature:** 0000039-setup-hardening-release-sizing
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-19

---

## Problem

The 0000039 design adds invalid JSON handling to the hook install step only. Other steps in the setup scripts also parse `settings.json` without a handler. The `allowedTools` step in `planifest-zero/setup.sh` (around line 542) calls `JSON.parse` with no `catch`. In `planifest-zero/setup.ps1`, the first `ConvertFrom-Json` in the hook install step (around line 330) and the later steps have no fixed error line either. A malformed file can reach those steps first and print a raw parse error, which can quote file content.

## Suggested Action

Give every setup step that parses `settings.json` the same fixed error line, file-unchanged guarantee, and exit 1. Share one helper per script. Add planted-value cases for each step.

## Why Deferred

The 0000039 scope names the hook install step only, and the human confirmed it. The wider fix touches more steps and needs its own parity cases in both suites.
