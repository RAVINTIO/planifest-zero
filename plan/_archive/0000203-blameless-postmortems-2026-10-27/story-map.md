# Story Map - 0000203-blameless-postmortems

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Resolve a stop | Orchestrator runs the skill after the Resolved line | US-001 | REQ-002 |
| Resolve a stop | Build a timeline with evidence | US-001 | REQ-001 |
| Resolve a stop | Ask why five times, ending at a process or tool gap | US-001 | REQ-001 |
| Resolve a stop | Reject a chain that ends at a person or agent | US-001 | REQ-001 |
| Resolve a stop | Write the record to `plan/postmortems/` | US-001 | REQ-001 |
| Close the gap | File each action as a backlog entry or repo instruction | US-002 | REQ-001 |
| Review the run | Read the postmortems in the build report | US-003 | REQ-002 |
| Review the run | Find the skill in the living docs | US-003 | REQ-002 |
| Resolve a stop | Detect triggers with a script | none | gap: out of scope |
| Ship the run | Block ship on a missing postmortem | none | gap: out of scope |

## Gaps

- Resolve a stop: the entry asks the orchestrator to run the skill. A detection script has no stated need.
- Ship the run: the entry asks the report to list postmortems, not to block ship.
