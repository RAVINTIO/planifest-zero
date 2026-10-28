---
title: "Backlog Entry: 0000219 - show what a step session is doing while it runs"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000219 - show what a step session is doing while it runs

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

The human can't see a feature build while a step runs. During initiative 0000195, the human asked three times for visibility of the step sessions.

The driver (`ravintio-zero/scripts/initiative-run.mjs`) starts each step with `claude -p` and the default text output. That output holds only the session's final reply. As a result:

- `plan/.initiative-logs/step-{n}.log` stays empty until the step ends.
- The watcher sees only build log lines and commits. A step can work for 20 minutes or more, through a test run or a subagent batch, with neither changing.
- The human sees no tool calls, no subagent starts, and no test progress.

## Suggested Action

- Start each step with `--output-format stream-json --verbose`, so the session writes one JSON event per message and tool call.
- Write the raw stream to the step log, as now.
- Add a reader, in the watcher or a new script, that turns the stream into short lines. Each line names the event kind and a short summary, such as `tool: Bash run-tests.sh`, `agent: started test-writer for REQ-002`, or `text: P3 Validate: Complete: ...`. Cut each line to 200 characters.
- Keep the driver's own output as it is. It never prints step session content.
- Keep the log private, with mode 600, as now. Tool output can hold file content.

## Wanted outcome

While a step runs, the human's session reports each tool call and subagent start within 30 seconds of it happening. Tests check these conditions:

- A stub step session that emits stream-json events produces one summary line per tool call in the order received.
- A summary line never exceeds 200 characters.
- The driver still prints no step session content to its own output.
- The initiative skill relays each summary line to the human's chat.

The human added the last condition at initiative 0000238 chart, on 2026-10-27.

## Why Deferred

The human asked for it while initiative 0000195 step 14 was about to start. The steps already charted don't cover it.
