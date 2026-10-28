---
title: "Feature Brief - stream step session activity"
summary: "Show tool calls and subagent starts from a running initiative step in the human's chat."
status: "approved"
version: "0.1.0"
---
# Feature Brief - stream step session activity

**Feature ID:** 0000240-stream-step-session-activity

> Built from backlog entry 0000219 by initiative 0000238 step 2. Entry folder deleted in the same commit.

## Business Goal

The human can't see what a step session does while it runs. The driver starts `claude -p` with text output, so the step log stays empty until the step ends. The human asked three times for visibility during initiative 0000195. Each tool call and subagent start must reach the human's chat within 30 seconds.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Stream-json step output | As an initiative owner, I want the driver to start each step with `--output-format stream-json --verbose`, so that the step log fills as the session works | must-have | 1 |
| Activity summary reader | As an initiative owner, I want the watcher to turn stream events into short lines, so that I see each tool call and subagent start | must-have | 1 |
| Relay to chat | As an initiative owner, I want the initiative skill to relay each summary line, so that I see activity in my chat | must-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack scripts, skills, standards, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-logs/step-{n}.log` | ravintio-zero (driver writes) | watcher reads only |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-run.mjs` | `claude -p` | CLI args | adds `--output-format stream-json --verbose` |
| `initiative-watch.mjs` | step log | file read | one JSON event per line, read by byte offset |

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ESM, no dependencies) |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Driver passes `--output-format stream-json --verbose`.
- Watcher reads the active step log and prints one `I-C Run: activity:` line per tool call, subagent start, and assistant text.
- Each printed line stays at 200 characters or fewer.
- Watcher stream poll drops to 10 seconds.
- Initiative skill relays each activity line to the human's chat.
- Roadmap standards describe the stream log and the activity line.

### Out of Scope
- A new script for the reader. It lives in `initiative-watch.mjs` (chart decision).
- Changes to `merge-guard`, `gate-write`, or any hook.
- Driver restart handling. Step 3 owns the planned restart.

### Deferred
- Tool result summaries. Only calls and starts are shown.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Latency | An event reaches the chat within 30 seconds | 10 second poll plus relay |
| Line length | 200 characters or fewer | Test on a long input |
| Privacy | Log stays mode 600. Driver prints no step content | Existing and new tests |

## Constraints and Assumptions

### Constraints
- No new dependency. No change to a fail-closed hook.
- The watcher writes no file.
- Skill files share a 1,720-line cap with 35 lines of headroom.

### Assumptions
- `claude -p --output-format stream-json --verbose` emits one JSON object per line with `type` `system`, `assistant`, `user`, or `result`. Tool calls appear as `tool_use` content items in `assistant` events. Impact if wrong: the reader prints nothing for unknown shapes.

## Scenario Paths

**Happy path:** The driver starts a step. The session calls Bash. The watcher prints `I-C Run: activity: tool: Bash ...` within 10 seconds. The skill relays it.

> As stated.

**First-run path:** The log does not exist yet. The watcher prints nothing and keeps polling.

> As stated.

**Error / sad path:** A line is not valid JSON, is truncated mid-write, or has an unknown shape. The watcher skips it and never crashes. A symlinked log stops the watcher with the existing refusal message.

> As stated.

**Cross-session continuity:** The watcher keeps its offset in memory. A restarted watcher starts at the end of the current log and prints new events only.

> As stated.

## Acceptance Criteria

- [ ] A stub step session that emits stream-json events produces one summary line per tool call, in the order received.
- [ ] A summary line never exceeds 200 characters.
- [ ] The driver prints no step session content to its own output.
- [ ] The initiative skill relays each summary line to the human's chat.
- [ ] The driver starts `claude` with `--output-format stream-json --verbose`.
