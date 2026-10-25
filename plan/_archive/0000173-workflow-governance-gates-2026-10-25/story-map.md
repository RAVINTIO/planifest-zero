---
title: "Story Map - 0000173-workflow-governance-gates"
summary: "The backbone of phase agent, maintainer, and reviewer activities, with the steps under each and the requirement that covers each step."
---
# Story Map - 0000173-workflow-governance-gates

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a phase | Write `Rework:` when a requirement goes round the loop again | US-003 | REQ-003 |
| Run a phase | Write `Requirement change:` for a mid-pipeline change | US-003 | REQ-003 |
| Pass a gate | Write `Gate revised:` when the human asks for a change | US-003 | REQ-003 |
| Hit an exception | Write `Blocked:` as before | US-003 | REQ-003 |
| Measure a run | Run the script on a run folder | US-001 | REQ-001 |
| Measure a run | Count markers outside fenced code only | US-001 | REQ-001 |
| Govern a run | Read thresholds from the pack standard | US-002 | REQ-002 |
| Govern a run | Mark each metric over its threshold as a breach | US-002 | REQ-002 |
| Ship a run | Add the section to the build report | US-004 | REQ-004 |
| Ship a run | Add the section to the PR description | US-004 | REQ-004 |
| Ship a run | Carry on when the script fails | US-004 | REQ-004 |
| Govern a run | Block ship on a breach | none | gap: out of scope |
| Compare runs | Trend metrics across the archive | none | gap: out of scope |

## Gaps

- A blocking gate is out of scope. The wanted outcome says the gate reports and never blocks.
- Trends across runs are out of scope. This release measures one run at a time.
