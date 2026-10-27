# Story Map - 0000199-reserve-ids-from-counter

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Reserve ids | Ask the script for N ids | US-001 | REQ-001 |
| Reserve ids | Read the ids and the next free id | US-001 | REQ-001 |
| Reserve ids | Start two reservations at once | US-001 | REQ-001 |
| Reserve ids | Bootstrap a repo with no counter | US-001 | REQ-002 |
| File an entry | Reserve an id before writing the entry | US-002 | REQ-003 |
| Copy an entry from another repo | Reserve a local id and name the source id | US-002 | REQ-003 |
| Resolve a counter conflict | Keep the higher value and renumber the later branch | none | gap: documented rule only |

## Gaps

- Resolve a counter conflict: the backlog entry pre-approves the answer and the docs state it. No code runs it.
