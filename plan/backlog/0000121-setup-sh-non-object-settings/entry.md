---
title: "Backlog Entry: 0000121 - setup.sh mishandles valid JSON that is not an object"
summary: "A settings.json holding an array reports hooks wired but stays unchanged, and null or a string stops setup with a node stack trace."
status: "open"
---
# Backlog Entry: 0000121 - setup.sh mishandles valid JSON that is not an object

**Source feature:** 0000039-setup-hardening-release-sizing
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-19

---

## Problem

`setup.sh` accepts any valid JSON in `.claude/settings.json` and then treats it as an object (`planifest-zero/setup.sh:476` and `planifest-zero/setup.sh:517`). I ran it in a scratch workspace with these inputs:

- `["x"]` makes setup print `~ .claude/settings.json (enforcement hooks wired)` and `(Agent added to allowedTools)`, but the file stays `["x"]`. `JSON.stringify` drops the properties set on an array. No Planifest hook is installed.
- `null` makes node throw `Cannot read properties of null (reading 'hooks')` and print a stack trace. Setup exits 1.
- `"text"` and `{"hooks":"text"}` make node throw a `TypeError` and print a stack trace. Setup exits 1.

No settings content reaches the output in these cases. The stack trace shows the setup script, not the file. The array case is a silent failure to install the enforcement hooks.

## Suggested Action

After the parse, check that the value is a plain object and `hooks` is absent or an object. If not, print one fixed line that names the file and exit 1. Decide the same rule for `setup.ps1` together with backlog 0000120.

## Why Deferred

The file is never damaged and nothing leaks. The fix needs a parity decision across both scripts, which 0000120 already raises.
