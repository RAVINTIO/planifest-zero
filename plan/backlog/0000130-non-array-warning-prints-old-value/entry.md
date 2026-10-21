---
title: "Backlog Entry: 0000130 - the non-array hook warning prints the old settings value"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000130 - the non-array hook warning prints the old settings value

**Source feature:** 0000040-setup-json-checks-and-park
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-21

---

## Problem

When `hooks.PreToolUse` or `hooks.UserPromptSubmit` in `settings.json` is present but not an array, setup warns and replaces it. The warning prints the old value in full (`setup.sh:495`, `setup.ps1:464`). A hook command that embeds a token or secret then reaches the terminal and any captured log. This is 0000038 F-006 and 0000039 F-001. Neither filed a backlog entry. 0000040 F-009 records it again.

## Suggested Action

Print the event name and the file only. If the old value must survive, write it to a `0600` backup file and print that file's path.

## Why Deferred

The path predates 0000040, and 0000040 does not touch it. It needs its own parity change in both setup scripts and their tests.
