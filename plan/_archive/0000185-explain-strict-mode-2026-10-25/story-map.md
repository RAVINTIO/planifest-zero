---
title: "Story Map - 0000185-explain-strict-mode"
summary: "The backbone of pack user activities around strict mode, with the steps under each and the requirement that covers each step."
---
# Story Map - 0000185-explain-strict-mode

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Find the explanation | Follow the strict mode row in `getting-started.md` | US-002 | REQ-002 |
| Find the explanation | Follow the `--strict-orchestrator` row in `README.md` | US-002 | REQ-002 |
| Understand strict mode | Learn how to turn it on | US-001 | REQ-001 |
| Understand strict mode | Learn how the banner and the ack file work together | US-001 | REQ-001 |
| Understand strict mode | Learn what the ack file holds and why it has that name | US-001 | REQ-001 |
| Run a roadmap | Learn why the driver's session sees the banner | US-001 | REQ-001 |
| Run a roadmap | Stop the banner in the driver's session | none | gap: out of scope |

## Gaps

- Stopping the banner in the driver's session needs a behaviour change. Backlog entry 0000182 holds it.
