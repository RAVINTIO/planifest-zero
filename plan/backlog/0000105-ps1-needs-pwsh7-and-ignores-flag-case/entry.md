---
title: "Backlog Entry: 0000105 - setup.ps1 needs PowerShell 7 features and ignores flag case"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000105 - setup.ps1 needs PowerShell 7 features and ignores flag case

**Source feature:** 0000034-setup-hardening
**Source phase:** P6
**Deferral source:** tech debt
**Date filed:** 2026-10-16

---

## Problem

`setup.ps1` calls `ConvertFrom-Json -AsHashtable` in `Merge-AllowedTools`, which Windows PowerShell 5.1 lacks, although the docs name 5.1 as supported. Its `switch` also matches `--strict-orchestrator` without regard to case, where `setup.sh` is case-sensitive (0000034 security report S-008).

## Suggested Action

Decide whether 5.1 is supported. If it is, replace `-AsHashtable`. Make the `switch` case-sensitive with `switch -CaseSensitive`. Fold in with backlog 0000090 and 0000094.

## Why Deferred

See the Tech Debt table in 0000034 `recommendations.md`. Both predate the feature.
