---
title: "Story Map - 0000192-rename-runner-lock-and-archive"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000192-rename-runner-lock-and-archive

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run an initiative | Start the driver, which takes `plan/.initiative-runner.lock` | US-001 | REQ-001 |
| Run an initiative | Start a second driver while the lock exists | US-001 | REQ-001 |
| Deliver an initiative | Archive to `plan/_archive/{id}-{slug}-initiative-{date}/` | US-002 | REQ-002 |
| Deliver an initiative | Finish a driver run whose initiative is already archived, in either form | US-002 | REQ-002 |
| Keep the rename complete | Run the old-name guard in CI | US-003 | REQ-003 |

## Gaps

None
