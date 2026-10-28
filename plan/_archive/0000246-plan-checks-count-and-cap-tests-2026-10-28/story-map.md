---
title: "Story Map - 0000246-plan-checks-count-and-cap-tests"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000246-plan-checks-count-and-cap-tests

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Plan a run | Scan the tests for counts, budgets, caps and ids | US-001 | REQ-001 |
| Plan a run | List each match in the unit that edits the file | US-001 | REQ-001 |
| Guard the scan | Fail a test when the skill or template drops it | US-001 | REQ-001 |
| Update an existing count test | Edit a test the scan names | none | gap: out of scope |

## Gaps

- Editing a test that the scan names belongs to the run that triggers it, so it is out of scope here.
