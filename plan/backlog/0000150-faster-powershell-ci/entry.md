---
title: "Backlog Entry: 0000150 - Faster PowerShell CI suites"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000150 - Faster PowerShell CI suites

**Source feature:** 0000043-autonomous-roadmaps
**Source phase:** P4
**Deferral source:** human request
**Date filed:** 2026-10-24

---

## Problem

The `windows-powershell` CI job sets the length of every run. It runs the PowerShell suites on Windows PowerShell 5.1, then on PowerShell 7, as two steps in one job. Over the last 40 runs, the 5.1 step took about 2 to 2.5 minutes and the 7 step took 2 to 4.5 minutes. A whole run took up to 7 min 15 s, while the Linux job took about 3 minutes.

PowerShell 7 is 40 to 75% slower than 5.1 in every run. Each test case builds a fresh workspace with a full copy of `planifest-zero/` and `git init`, then starts a new `pwsh` process to run `setup.ps1`. The start-up cost is the likely cause, but no run has measured it.

## Suggested Action

1. Time `pwsh` start-up, the workspace copy, and `setup.ps1` per test case, and record which one dominates.
2. Run the 5.1 and 7 suites as a two-entry job matrix, so they run in parallel.
3. If start-up dominates, run several cases in one `pwsh` process. If the copy dominates, copy only the files `setup.ps1` reads.
4. Decide whether the Linux job still needs the PowerShell suites, which add about 90 seconds there.

## Why Deferred

It does not concern roadmaps. The human asked to commit it with the next feature.
