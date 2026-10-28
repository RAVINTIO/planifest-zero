---
title: "Story Map - 0000239-test-suite-reliability"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000239-test-suite-reliability

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Write a suite | Call an `assert_*` helper | US-001 | REQ-001 |
| Write a suite | Check that a string is absent | US-001 | REQ-001 |
| Run a suite | See a failure for an undefined helper | US-001 | REQ-001 |
| Run P3 in a step | Run the installed-copies check | US-002 | REQ-002 |
| Run P3 outside an initiative | See a stale install fail | US-002 | REQ-002 |

## Gaps

- None.
