---
title: "Scope - stream step session activity"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - stream step session activity

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Version:** 0.31.0

## In Scope

- Driver passes `--output-format stream-json --verbose` to `claude -p`.
- Watcher reads the step log by byte offset and prints `I-C Run: activity:` lines for tool calls, subagent starts, and assistant text.
- Each line is 200 characters or fewer in total.
- Watcher poll drops from 30 to 10 seconds.
- Initiative skill relays each activity line. Roadmap standards describe the stream log.
- Tests for each requirement, and docs.

## Out of Scope

- A new reader script.
- Changes to `merge-guard`, `gate-write`, or any fail-closed hook.
- Tool result summaries.
- Driver restart handling (step 3).
- Tool result content, which can hold file content.

## Deferred

- Tool result summaries. Blocked until the human asks for them.
