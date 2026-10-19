---
title: "Backlog Entry: 0000122 - Test-JsonText slows on very deep nesting"
summary: "The nesting stack in setup.ps1 Test-JsonText is a string that grows by copy, so cost rises with the square of the depth."
status: "open"
---
# Backlog Entry: 0000122 - Test-JsonText slows on very deep nesting

**Source feature:** 0000039-setup-hardening-release-sizing
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-19

---

## Problem

`Test-JsonText` in `planifest-zero/setup.ps1` keeps its nesting stack in a string. Each open bracket runs `$stack += '{'` (lines 331 and 332) and each close runs `Substring` (line 334). Both copy the string. A `settings.json` nested a few hundred thousand levels deep makes the check slow, because the cost grows with the square of the depth. Windows PowerShell 5.1 and PowerShell 7 also cap `ConvertFrom-Json` depth, so such a file can never succeed. I reasoned this from the code. `pwsh` is not installed on the review machine, so I did not time it.

## Suggested Action

Track depth with an integer and a `[System.Collections.Generic.Stack[char]]`, or stop the check with a failure once the depth passes 1024.

## Why Deferred

A real `settings.json` is small and the user owns it. The worst case is a slow failed run, with no leak and no file change.
