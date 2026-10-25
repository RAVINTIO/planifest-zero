---
title: "Story Map - 0000172-subagent-acceleration"
summary: "The backbone of human, phase agent, and maintainer activities, with the steps under each and the requirement that covers each step."
---
# Story Map - 0000172-subagent-acceleration

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start a run | Choose `fast` or `standard` at discovery | US-001 | REQ-001 |
| Start a roadmap step | Take the run speed from the roadmap | US-001 | REQ-001 |
| Resume a run | Keep the run speed without a question | US-001 | REQ-001 |
| Run a phase | Dispatch the phase's fast batch in one message | US-002 | REQ-002 |
| Run a phase | Keep the gate and the exception stops | US-002 | REQ-002 |
| Close a phase | Record the end time and wall-clock time | US-003 | REQ-003 |
| Ship a run | Read agent counts and wall-clock time in the build report | US-003 | REQ-003 |
| Run a phase | Start phase N+1 work while phase N runs | none | gap: out of scope |
| Compare runs | Compare fast and standard wall-clock times | none | gap: out of scope |

## Gaps

- Overlapping phases are out of scope. The wanted outcome keeps phases in order.
- A comparison across runs is out of scope. This release records the data a later release can compare.
