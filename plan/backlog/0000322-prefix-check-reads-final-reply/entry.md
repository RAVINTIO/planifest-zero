---
title: "Backlog Entry: 0000322 - the prefix check reads the final reply, not an earlier note"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000322 - the prefix check reads the final reply, not an earlier note

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`check-reply-prefix.mjs` warns about replies that do have a prefix. It reads the transcript at Stop and takes the last assistant message with text (`check-reply-prefix.mjs:60-74`). At that moment the transcript doesn't yet hold the final reply, so the hook takes an earlier mid-turn note.

In `ravintio/docs` session `b4780693`, every warning on 2026-10-30 and 2026-10-31 matches this pattern. Each logged snippet is a mid-turn note, and the final reply, written within a millisecond of the warning, has a valid prefix:

| Logged as a miss (`plan/.prefix-misses.log`) | Final reply |
|---|---|
| 06:16:45 "Now I'll write the sentinel, ack, build log, and discovery record." | "P0 Discovery: Blocked: I need the list of copy bugs." |
| 08:21:45 "I'm still reviewing the site. I'll check two facts…" | "P0 Discovery: I've reviewed the other nine pages…" |
| 13:14:29 "Yes. The confirmed copy text exists only in this conversation…" | "P0 Discovery: Complete: the design is confirmed…" |

The false warnings caused the confusion that entry 0000258 records. They also fill the miss log with replies that didn't miss.

## Suggested Action

- At pickup, check the Claude Code hooks docs for a field in the Stop payload that holds the final reply. If one exists, check that field and stop reading the transcript.
- Otherwise, check only an assistant message that ends the turn, one with no `tool_use` block after the last user prompt. If the transcript doesn't hold one yet, reread it a few times over about one second.
- If the final reply still can't be found, exit silently. An advisory hook must not warn on a guess.
- Keep the hook advisory. It never blocks.

## Wanted outcome

The prefix check warns only when the final reply lacks a prefix. Tests check these conditions:

- A transcript whose final reply has a prefix, after an unprefixed mid-turn note, gives no warning.
- A transcript whose final reply lacks a prefix gives a warning that quotes that reply.
- A transcript that ends on a `tool_use` block, with no final reply yet, gives no warning.

## Why Deferred

The human asked for it on 2026-10-31, after the warning kept appearing in the `ravintio/docs` session. No run is active.
