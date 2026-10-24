---
title: "Backlog Entry: 0000159 - setup.ps1 run time dominates the PowerShell CI suites"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000159 - setup.ps1 run time dominates the PowerShell CI suites

**Source feature:** 0000151-hardening-efficiency-and-ci
**Source phase:** P3
**Deferral source:** deliberate scope decision
**Date filed:** 2026-10-24

---

## Problem

The 0000151 timing lines measured each PowerShell test case in CI run `40106508296`. Across both Windows jobs, the totals were as follows:

| Part | Total | Cases |
|------|-------|-------|
| `setup.ps1` | 210.1 s | 111 |
| Workspace copy | 42.1 s | 123 |
| `pwsh` start-up | 25.5 s | 111 |

`setup.ps1` takes about 75% of the measured time, at about 1.9 s per case. Host start-up takes under 10%. So batching cases into one process, the deferred 0000150 action, would save little.

## Suggested Action

Profile one `setup.ps1` run under each host and find its slowest step. Then decide whether to speed that step up, or to share one setup run across the cases that need the same starting state.

## Why Deferred

0000151 scope deferred batching until timing showed start-up dominates. Timing shows `setup.ps1` dominates instead, which is a different change.
