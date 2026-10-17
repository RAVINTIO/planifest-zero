---
title: "Backlog Entry: 0000115 - setup.ps1 truncates settings.json values deeper than 10 levels"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000115 - setup.ps1 truncates settings.json values deeper than 10 levels

**Source feature:** 0000038-setup-hook-filter-fixes
**Source phase:** P4 (security finding F-004, Low, first raised as 0000037 S-003)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-17

---

## Problem

`planifest-zero/setup.ps1` rewrites `settings.json` with `ConvertTo-Json -Depth 10`. Windows PowerShell 5.1 replaces any value deeper than 10 levels with its type name and gives no warning. A user setting nested that deep is lost.

## Suggested Action

Raise `-Depth` to 100 at each `ConvertTo-Json` call that writes `settings.json`. Add a deep-nesting case to a `.ps1` setup suite.

## Why Deferred

The behaviour predates 0000038, and the run's scope covers the hook filter only.
