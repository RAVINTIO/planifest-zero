---
title: "Story Map - 0000240-stream-step-session-activity"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000240-stream-step-session-activity

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a step | Driver starts the session with stream output | US-001 | REQ-001 |
| Run a step | Driver keeps step content private | US-001 | REQ-004 |
| Watch a step | Watcher reads events and prints one line each | US-002 | REQ-002 |
| Watch a step | Watcher keeps lines short | US-002 | REQ-003 |
| Watch a step | Human sees the lines in chat | US-003 | REQ-005 |
| Watch a step | Watcher restarts mid-step | US-002 | REQ-002 |

## Gaps

- Tool result summaries: gap: out of scope. The brief defers them.
