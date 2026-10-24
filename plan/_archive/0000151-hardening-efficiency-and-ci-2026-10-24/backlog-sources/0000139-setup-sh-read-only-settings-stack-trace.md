---
title: "Backlog Entry: 0000139 - setup.sh prints a stack trace on a read-only settings.json"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000139 - setup.sh prints a stack trace on a read-only settings.json

**Source feature:** 0000041-setup-cleanup-and-park-hardening
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-22

---

## Problem

If `.claude/settings.json` is read-only (mode `444`), `install_enforcement_hooks` in `planifest-zero/setup.sh` fails in `writeSettings`. Its `fs.accessSync(target, fs.constants.W_OK)` throws `EACCES`, and nothing catches it. Node prints the full stack trace to stderr, with the absolute path of the settings file. Setup then exits 1.

The telemetry cleanup handles the same error with one warning line. The install step has no fixed line for a write error. That breaks the pattern of 0000039 ADR-002, where setup never shows a raw node error.

To reproduce, plant a valid settings object, run `chmod 444 .claude/settings.json`, and run `bash planifest-zero/setup.sh claude-code`.

## Suggested Action

Catch a write error in the install step and print one fixed line that names the file by its relative path. Then exit 1. Check whether `setup.ps1` needs the same change.

## Why Deferred

The fault is in the hook install step's write path, not in the cleanup or the warning text that 0000041 changes. It needs its own line text and a parity decision for `setup.ps1`.
