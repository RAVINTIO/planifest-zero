# Story Map - 0000204-run-and-initiative-retrospectives

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Ship a run | Ship runs the skill in run mode after the build report | US-001 | REQ-002 |
| Ship a run | Review what helped, what slowed the run, and what to try next | US-001 | REQ-001 |
| Ship a run | Write the record to `plan/retrospectives/` | US-001 | REQ-001 |
| Deliver an initiative | Delivery runs the skill in initiative mode before the PR | US-002 | REQ-002 |
| Deliver an initiative | Compare charted steps with what shipped, and find repeated friction | US-002 | REQ-001 |
| Close the gap | File each change as a backlog entry or repo instruction | US-003 | REQ-001 |
| Plan the next run | Read the latest retrospectives at P0 and at chart | US-004 | REQ-002 |
| Find the skill | Name it in the living docs and the skill counts | US-001 | REQ-003 |
| Ship a run | Block ship on a missing retrospective | none | gap: out of scope |
| Plan the next run | Turn past stops into chart-time decisions | none | gap: backlog 0000186 |

## Gaps

- Ship a run: the entry asks for a record, not for a block on a missing one.
- Plan the next run: chart-time decisions from past stops belong to backlog entry 0000186.
