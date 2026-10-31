# Story Map - 0000202-improvement-loops

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Finish a requirement | Reach GREEN and refactor | US-001 | REQ-001 |
| Finish a requirement | Dispatch a fresh reviewer | US-001 | REQ-001 |
| Finish a requirement | Apply the finding and run the suite | US-001 | REQ-001 |
| Finish a requirement | Stop at 2 cycles or when nothing is found | US-001 | REQ-001 |
| Finish a requirement | Revert a change that breaks the suite | US-001 | REQ-001 |
| Review the run | Read one marker per cycle in the build log | US-002 | REQ-002 |
| Review the run | Read the marker forms in the standard | US-002 | REQ-002 |
| Review the run | Find the loop in the living docs | US-002 | REQ-002 |
| Validate the work | Review the passing solution for a cleaner design | none | gap: out of scope |
| Review the run | Compare cycle counts with a threshold | none | gap: out of scope |

## Gaps

- Validate the work: the wanted outcome names the build log after GREEN per requirement, which is P2. P3 keeps its failure loops.
- Review the run: `workflow-metrics.mjs` counts four markers against thresholds. A threshold for improvement cycles has no stated value, so the entry does not ask for one.
