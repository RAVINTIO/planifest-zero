---
title: "Build Log - 0000197-merge-guard-block-message"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000197-merge-guard-block-message

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000197-merge-guard-block-message` |
| Pipeline start | `2026-10-27T07:33:10Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-10-27T07:33:10Z` |
| End | `2026-10-27T07:36:00Z` |
| Wall clock | `3` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | I-C Run: initiative 0000195, step 2 of 13 |

- I-C Run: Starting: step 2 of initiative 0000195-backlog-clearance
- Migrations: 0004 and 0005 skipped, `Applies when:` is false (no earlier-brand folder, no draft under the earlier initiative name, no earlier branch pattern in the workflow).
- Branch: `feat/0000197-merge-guard-block-message`, cut from `initiative/0000195-backlog-clearance`.
- Run mode: autonomous (2026-10-27T07:33:10Z, initiative step)
- Run speed: standard (2026-10-27T07:33:10Z, initiative `**Speed:**` field)
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds feature directories and `docs/about.md` exists)
- Backlog pickup: 0000190 pulled into the brief per the initiative row. Folder deleted in the same commit.
- Version: last known 0.20.0, step bump `patch`, new version 0.20.1.
- Observed: the first attempt to write these artifacts with a long heredoc was blocked by merge-guard with the "over 4096 characters" reason. This reproduces backlog entry 0000190. The Write tool avoids it.
- Scope Lock (happy path): a plain squash merge into `initiative/*` and a command with no merge words pass as before. [source: draft-accepted (initiative)]
- Scope Lock (first-run path): a command that writes a heredoc naming `gh pr merge` stays blocked and the message points to the Write tool. [source: draft-accepted (initiative)]
- Scope Lock (error path): an over-4096 command and a merge-words-in-text command both stay blocked, each with its own reason. [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): the hook holds no state, so each command is judged alone. [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
- Design confirmation: draft-accepted (initiative)
