---
title: "Backlog Entry: 0000190 - merge-guard blocks long commands that mention a merge"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000190 - merge-guard blocks long commands that mention a merge

**Source feature:** 0000189-name-the-roadmap-initiative
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-26

---

## Problem

The `merge-guard` hook (`ravintio-zero/hooks/enforcement/merge-guard.mjs`) blocked a Bash command that only wrote Markdown files with a heredoc. The heredoc text named the squash merge command in a requirement. The command ran over 4096 characters, so the hook refused it. The message said the hook could not confirm a squash into the carve-out branch pattern, because the command is over 4096 characters.

The hook matches the merge words anywhere in the command, including heredoc bodies and quoted strings. Any long file write that mentions the command trips it.

## Suggested Action

Skip heredoc bodies when the hook matches the merge words. Another option is to match only the command words outside quoted text. Add a test with a long heredoc that names the command.

## Why Deferred

The workaround is to write files with the Write tool. Changing the hook's matching rule needs its own design decision and security review, which this rename feature does not cover.
