---
title: "Requirement: REQ-002 - Watcher prints one summary line per event"
summary: "Watcher prints one summary line per event"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Watcher prints one summary line per event

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want the watcher to turn stream events into short lines, so that I see each tool call and subagent start.

## Functional Requirements
- The watcher reads the log for the current `position` by byte offset and parses each complete line as JSON.
- Each `tool_use` item in an `assistant` event prints `I-C Run: activity: tool: {name} {detail}`.
- A `tool_use` named `Task` or `Agent` prints `I-C Run: activity: agent: started {subagent_type} {description}`.
- Assistant `text` items print `I-C Run: activity: text: {first line}`.
- Lines print in the order received. A partial last line waits for the next poll. Invalid JSON and unknown shapes are skipped.
- The watcher starts at the end of the log, so a restart prints new events only. `--since-bytes {n}` is a test aid.
- `POLL_MS` is 10000.

## Acceptance Criteria
- [ ] AC-1: one line per tool call in order
  - Given a log with three `tool_use` events and one `Task` event
  - When the watcher runs one pass with `--since-bytes 0`
  - Then it prints four activity lines in the order received, the last starting `agent: started`
- [ ] AC-2: bad input is skipped
  - Given a log with an invalid JSON line, an unknown event type, and a partial last line
  - When the watcher runs one pass
  - Then it prints no line for them and exits 0
- [ ] AC-3: poll interval
  - Given the watcher source
  - When `POLL_MS` is read
  - Then it equals 10000

## Dependencies
- REQ-001
