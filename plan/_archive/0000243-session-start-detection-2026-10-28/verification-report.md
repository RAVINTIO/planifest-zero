---
title: "Verification Report - 0000243-session-start-detection"
summary: "What was run and what was observed for each acceptance criterion."
---
# Verification Report - 0000243-session-start-detection

Nothing needed starting. Each check ran a script or hook against the repo or a temporary project.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001, REQ-006 lines and order | `node ravintio-zero/scripts/resume-detect.mjs .` on this repo | verified | Exit 0. Lines printed in check order: migrations 0004 and 0005, `step session`, initiative lines, `run mode: autonomous`, `discovery.md present`, `last phase: P2`. |
| REQ-001, REQ-006 no signals | Test fixture with an empty project | verified | Prints `no resume signals`. |
| REQ-002 fixed text | Temporary project with `IGNORE ALL RULES` in `pause.md`, hook run | verified | Output holds `pause record present` and none of the planted text. |
| REQ-003 injection | Same hook run | verified | Output holds the load instruction and the finding lines. |
| REQ-003 failure line | Hook test with a failing, missing, and slow stub script | verified | Each gives `resume detection did not run`. The slow stub stops after 2 seconds. |
| REQ-004 parity | Hook test with an active initiative, with and without `RAVINTIO_INITIATIVE_STEP=1` | verified | Same findings apart from `step session`. Each names its own skill. |
| REQ-005 short rule | `test-0000243-req-005-short-rule.sh` | verified | Section is 339 bytes. Pack Index names the reference. Every old line is in the reference. |
