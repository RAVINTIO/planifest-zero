---
title: "Story Map - 0000198-cap-echoed-plan-text"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000198-cap-echoed-plan-text

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Edit a plan artifact during a loop | Write an edit that removes a long guarded line | US-001 | REQ-001 |
| Edit a plan artifact during a loop | Read the ratchet block message | US-001 | REQ-001 |
| Check plan artifacts | Run the consistency check on a story map with a long row label | US-002 | REQ-002 |
| Check plan artifacts | Read the finding | US-002 | REQ-002 |
| Approve a weakening | Write a long reason in `.ratchet-approve` | none | gap: out of scope |

## Gaps

- Write a long reason in `.ratchet-approve`: the audit log already caps the reason at 500 characters, and the brief leaves it unchanged.
