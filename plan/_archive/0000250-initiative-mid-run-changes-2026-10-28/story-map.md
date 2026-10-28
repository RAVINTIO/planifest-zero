---
title: "Story Map - 0000250-initiative-mid-run-changes"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000250-initiative-mid-run-changes

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Take a repo instruction during a run | Queue the instruction while the driver lock is held | US-001 | REQ-001 |
| Take a repo instruction during a run | Add it to the scope of the current or next pending step in `initiative.md` | US-001 | REQ-001 |
| Take a repo instruction during a run | Leave the override write to the step | US-001 | REQ-001 |
| Run steps in sequence | Compare the initiative branch before and after each step | US-002 | REQ-002 |
| Run steps in sequence | Stop and name the changed files when the driver, watcher, or initiative skill changed | US-002 | REQ-002 |
| Run steps in sequence | Give no restart when none of the three changed | US-002 | REQ-002 |
| Report a stop | Restart the driver and the watcher on the restart stop | US-003 | REQ-001 |

## Gaps

None.
