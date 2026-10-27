---
title: "Story Map - 0000196-setup-argument-checks"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000196-setup-argument-checks

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run setup | Pass the tool argument | US-001 | REQ-001 |
| Run setup | Pass a retired flag | US-002 | REQ-002 |
| Run setup | Read the rejection message | US-002 | REQ-002 |
| Refresh setup | Read the flags from a record or marker | US-003 | REQ-003 |
| Refresh setup | Confirm the proposed command | US-003 | REQ-003 |
| Run setup | Pass an unknown flag | none | gap: out of scope |

## Gaps

- Pass an unknown flag: it already fails during argument parsing, so the brief leaves it out of scope.
