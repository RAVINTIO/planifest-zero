# Design - 0000240-stream-step-session-activity

## Feature
- Problem: A running initiative step shows no tool calls or subagent starts to the human, because the step log stays empty until the step ends.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000240-stream-step-session-activity
- Version: 0.31.0 (minor bump from 0.30.2, per the step row)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As an initiative owner, I want the driver to start each step with stream-json output, so that the step log fills as the session works
  - US-002: As an initiative owner, I want the watcher to turn stream events into short lines, so that I see each tool call and subagent start
  - US-003: As an initiative owner, I want the initiative skill to relay each line, so that I see activity in my chat
- Acceptance criteria confirmed: 5
- Constraints: no new dependency, no hook change, watcher writes no file, driver prints no step content
- Integrations: none

## Architecture Layer
- Latency target: an event reaches the chat within 30 seconds (watcher poll 10 seconds)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: local scripts only. Log stays mode 600 and private. The watcher refuses symlinks. Data classification: step logs may hold file content, treat as private.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Bash tests, GitHub Actions, Build target: local
- Components: `ravintio-zero` - pack scripts, skills, standards, tests
- Data ownership: `plan/.initiative-logs/step-{n}.log` -> `ravintio-zero` (driver writes, watcher reads)
- Deployment: none
- API versioning: not applicable
- Design decisions:
  - D-1: Driver adds `--output-format stream-json --verbose` (chart Decisions row, step 2). Decision applied (initiative chart).
  - D-2: The reader lives in `initiative-watch.mjs`, not a new script. Decision applied (initiative chart).
  - D-3: The watcher reads the log of the current `position` by byte offset, buffers a trailing partial line, and skips lines that are not valid JSON.
  - D-4: Summary kinds: `tool: {name} {detail}` for each `tool_use` (Task and Agent calls print `agent: started {subagent_type} {description}`), and `text: {first line}` for assistant text. Detail is the Bash command, file path, pattern, or similar first string input.
  - D-5: The printed line `I-C Run: activity: {summary}` is cut to 200 characters in total. Existing event lines keep their 500 limit.
  - D-6: `POLL_MS` drops from 30000 to 10000. Heartbeat and stale intervals stay.
  - D-7: The watcher starts at the end of the current log, so a restart prints new events only. `--since-bytes` is a test aid, as `--since-lines` is.

## Scope
- In: driver args, watcher reader, 10 second poll, skill relay rule, roadmap standards text, tests, docs
- Out: new reader script, hook changes, tool result summaries, driver restart handling
- Deferred: tool result summaries

## Assumptions
- stream-json emits one JSON object per line, with tool calls as `tool_use` items in `assistant` events - impact if wrong: the reader prints nothing for that shape and the log still holds the raw stream

## Risks
- Unknown event shapes in a later Claude Code release: likelihood medium, impact low. The reader skips what it can't parse.
- Skill line cap: likelihood medium, impact medium. Keep the skill addition to 6 lines or fewer. The cap test fails otherwise.
- Raw stream in the log is larger than before: likelihood high, impact low.

## Dependencies
- Upstream: none
- Downstream: step 3 (watcher false events) edits the same watcher file
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver stream args | ravintio-implement | One-line script change with a test |
| REQ-002 - reader order | ravintio-implement | Pure parsing function |
| REQ-003 - 200 character cap | ravintio-implement | Pure parsing function |
| REQ-004 - driver prints no content | ravintio-implement | Test with a stub binary |
| REQ-005 - skill relay and docs | ravintio-implement | Text change with a grep test |

## Repo Instructions
custom-001 to custom-006 under `ravintio-overrides/instructions/`: work on a feat/ branch, commit granularly, delegate parallel work to subagents, push and raise the PR at ship, never merge to main, setup refresh approval for the exact command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 06:42 a.m. GMT
