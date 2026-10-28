---
title: "Story Map - 0000251-driver-step-fixes"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000251-driver-step-fixes

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the tests in a step session | Start a runner with the step variable set | US-001 | REQ-001 |
| Run the tests in a step session | Clear the variable before any suite starts | US-001 | REQ-001 |
| Run the tests in a step session | Let a suite set the variable for its own hook call | US-001 | REQ-001 |
| Re-run a step | Rename the existing step log to the next free attempt name | US-002 | REQ-002 |
| Re-run a step | Open a fresh step log with the same name | US-002 | REQ-002 |
| Re-run a step | Refuse a symlink and keep mode 600 | US-002 | REQ-002 |
| Read a stop line | Name the attempt logs in the stop line | US-003 | REQ-002 |

## Gaps

None.
