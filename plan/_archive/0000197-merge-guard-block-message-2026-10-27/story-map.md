---
title: "Story Map - 0000197-merge-guard-block-message"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000197-merge-guard-block-message

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Write a file from Bash | Run a heredoc that names the merge command | US-001 | REQ-001 |
| Write a file from Bash | Read the block message | US-001 | REQ-001 |
| Write a file from Bash | Switch to the Write tool | US-001 | REQ-001 |
| Merge a step PR | Run a plain squash merge | none | gap: out of scope |

## Gaps

- Run a plain squash merge: the guard already passes it, and the brief leaves the block set unchanged.
