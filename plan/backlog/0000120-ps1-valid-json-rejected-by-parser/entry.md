---
title: "Backlog Entry: 0000120 - setup.ps1 calls some valid JSON invalid"
summary: "A settings.json that node accepts but ConvertFrom-Json rejects gets the invalid-JSON error from setup.ps1."
status: "open"
---
# Backlog Entry: 0000120 - setup.ps1 calls some valid JSON invalid

**Source feature:** 0000039-setup-hardening-release-sizing
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-19

---

## Problem

`setup.ps1` checks `settings.json` with a strict JSON check, then parses it with `ConvertFrom-Json` (0000039 req-001). Some valid JSON passes the check but fails the parse. PowerShell 7 rejects keys that differ only by case, such as `{"a":1,"A":2}`. Node's `JSON.parse` accepts them. A top-level `null` also parses to nothing in `Merge-EnforcementHookSettings`.

In each case, `setup.ps1` prints `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` and exits 1. `setup.sh` may continue on the same file, so the two scripts can differ.

## Suggested Action

Print a separate fixed message when the text is valid JSON but PowerShell cannot read it as an object. Then decide what `setup.sh` does with the same input.

## Why Deferred

The file stays unchanged and nothing leaks, so the edge case is safe. Fixing it needs its own parity decision across both scripts.
