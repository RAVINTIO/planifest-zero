---
title: "Backlog Entry: 0000190 - merge-guard gives the wrong reason when it blocks a file write"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000190 - merge-guard gives the wrong reason when it blocks a file write

**Source feature:** 0000189-name-the-roadmap-initiative
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-26

---

## Problem

The `merge-guard` hook (`ravintio-zero/hooks/enforcement/merge-guard.mjs`) blocked a Bash command that only wrote Markdown files with a heredoc. The heredoc text named the squash merge command in a requirement. The block message said the command was over 4096 characters.

That reason misleads the agent. The hook blocks any command whose text names the merge command outside a plain `gh pr merge` call, at any length. `evaluate()` splits the command at line breaks, so each heredoc line counts as a segment of its own. A line that names the command fails the plain-call check in `parsePlain()`. The message never says that the merge words sit in text, or that the Write tool avoids the block.

The block itself is correct. The hook fails closed, and it must keep blocking these commands. A command can run text that it first writes to a file or feeds to a program, so the hook can't treat any of that text as harmless.

## Suggested Action

Change only the message. When a segment that holds the merge words is not a bare `gh pr merge` call, the message says that the command names a merge in text that isn't a merge call. It tells the agent to write files with the Write tool. The over-4096 message gets the same advice.

Don't change which commands the hook blocks or passes. Don't skip heredoc bodies or quoted text.

## Wanted outcome

A command that writes a heredoc naming `gh pr merge` still fails the hook, both under and over 4096 characters. The block message for each case names the Write tool. Every existing merge-guard test passes unchanged, apart from tests that assert the old message text.

## Why Deferred

The workaround is to write files with the Write tool. The rename feature didn't cover the hook. On 2026-10-26, at the initiative 0000195 chart, the human limited this entry to the message. An earlier draft of the entry proposed skipping heredoc bodies or quoted text. The human rejected that, because it would weaken the guard.
