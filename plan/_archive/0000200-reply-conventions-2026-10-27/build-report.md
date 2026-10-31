# Build report - 0000200-reply-conventions

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Parallelism |
|-------|--------|------------|----------------------|-------------|
| P0 Discovery | 0 | primary | 10 | none |
| P1 Plan | 0 | primary | 10 | none |
| P2 Implement | 2 | primary, cheaper | 29 | 1 batch of 2 |
| P3 Validate and Accept | 0 | primary | 14 | none |
| P4 Ship | 0 | primary | 10 | none |

Phase times are estimates read from the session clock.

## Parallelism

P2 ran the docs requirements (REQ-001 and REQ-002) beside the hook requirement (REQ-003) in one batch of two subagents. REQ-004 ran inline after REQ-003, because it wires the hook file. P1 ran inline, because the artifacts share one set of facts.

## Self-corrections

1. The miss log was not excluded from git. Verification by execution found it, because the suite checked output and log content but not git status. Avoidable: the risk register already named the log as untracked, and a test for the exclusion at P1 would have caught it.
2. A subagent ran `git stash` for a baseline and took the other agents' uncommitted edits. The parent restored them with `git stash pop`. Avoidable: the brief did not forbid git state changes. Add that to the dispatch template for parallel agents that share a working tree.

## Improvement suggestions

- P2: seven suites asserted text the change altered. Search the tests for the event and file names before editing, as the 0000199 report advised.
- P2: tell parallel subagents in one working tree to leave git state alone.
- P3: check `git status` after any step that writes a runtime file.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
