---
title: "Backlog Entry: 0000307 - the orchestrator auto-trigger fires once per session"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000307 - the orchestrator auto-trigger fires once per session

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`auto-trigger-orchestrator.mjs` fires on every prompt. It treats a missing `plan/.orchestrator-active` as "orchestrator not yet loaded" (`auto-trigger-orchestrator.mjs:7`).

Outside a run, that file never exists. On 2026-10-31, every prompt in a supervision session carried "Load the ravintio-orchestrator skill now, before responding to the user's prompt", even after the skill had loaded. An instruction that repeats on every prompt trains the reader to ignore it.

## Suggested Action

- Record the session id when the orchestrator or initiative skill loads, for example in an ignored `plan/.orchestrator-loaded` file.
- Fire the instruction only when the recorded session id differs from the current one.
- Keep today's behaviour for a new session, and after `/clear` or compaction if the host gives a new session id.
- Apply the same rule in `check-orchestrator-presence.mjs`, which shares the condition.
- At pickup, confirm which session id the host passes to `UserPromptSubmit` hooks.

## Wanted outcome

The load instruction appears once per session. Tests check these conditions:

- The first prompt of a session with no run gets the instruction.
- A second prompt in the same session gets none.
- A prompt from a new session id gets the instruction again.

## Why Deferred

The human asked for it on 2026-10-31, from noise in a supervision session. No run is active.
