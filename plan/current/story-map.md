# Story Map - 0000201-plan-concurrent-work

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Write the execution plan | Fill the concurrency table from the template | US-001 | REQ-001 |
| Write the execution plan | Read the guide for each column | US-001 | REQ-001 |
| Re-plan after a reopened phase | Rewrite the concurrency table | US-001 | REQ-001 |
| Choose batches | Place independent units in one batch | US-002 | REQ-002 |
| Choose batches | State a reason for a unit that runs alone | US-002 | REQ-002 |
| Dispatch work | Dispatch by the plan's batches | US-002 | REQ-002 |
| Dispatch work | Record a departure from the plan | US-002 | REQ-002 |
| Pass the plan gate | Run the consistency check on the plan | US-003 | REQ-003 |
| Pass the plan gate | Fix a finding and re-run | US-003 | REQ-003 |
| Review batch speed | Measure time saved by the batches | none | gap: out of scope |

## Gaps

- Review batch speed: the build log already records parallel task batch counts per phase. No tool compares plan batches to dispatch, and the entry does not ask for one.
