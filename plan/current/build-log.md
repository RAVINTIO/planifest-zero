---
title: "Build Log - 0000173-workflow-governance-gates"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000173-workflow-governance-gates

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000173-workflow-governance-gates` |
| Pipeline start | `2026-10-25T12:28:59Z` |
| Tool | `claude-code` |
| Primary model | `opus` |
| Cheaper model | `haiku` |
| Run speed | `standard` |
| Roadmap | `0000168-backlog-clearance`, step 5 of 6 |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-10-25T12:28:59Z` |
| End | `2026-10-25T12:30:09Z` |
| Wall clock | `1 min` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Roadmap step. Discovery read the roadmap standard, the ship skill, and the log templates inline. Each read fed the next, so no subagent applied. |

R-C Run: Starting: step 5 of roadmap 0000168 (0000173-workflow-governance-gates)
Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists). Assumed as the only signal.
Pending migration `0004-ravintio-rename.md` skipped. Its `Applies when:` condition is false in the pack source.
Run mode: autonomous (2026-10-25T12:28:59Z, roadmap step)
Run speed: standard (2026-10-25T12:28:59Z, roadmap has no `**Speed:**` field)
Backlog pull-in (roadmap row): 0000100.
Version: 0.18.0 (minor, roadmap `Bump`, from 0.17.0)
Scope Lock (happy path): At ship, the script derives the four metrics from the build log and loop-state files, and the build report and PR description show them with any breach. [source: draft-accepted (roadmap)]
Scope Lock (first-run path): A run folder with no marker lines reports 0 for each marker metric and no breach. [source: draft-accepted (roadmap)]
Scope Lock (error path): If the script cannot read the build log or the thresholds table, ship writes "Workflow governance: not measured" with the reason and carries on. The gate never blocks. [source: draft-accepted (roadmap)]
Scope Lock (cross-session continuity): The markers live in the committed build log and loop-state files, so a resumed session keeps every count. [source: draft-accepted (roadmap)]
Scope Lock complete. All four scenario paths captured.
P0 exchange (design): Q: Confirm the design? / A: draft-accepted (roadmap). (2026-10-25T12:30:09Z)
P0 Discovery: Complete: design self-confirmed for roadmap step 5. (2026-10-25T12:30:09Z)
