---
title: "Security Report - 0000240-stream-step-session-activity"
summary: "Security review of the stream reader and driver change."
---
# Security Report - 0000240-stream-step-session-activity

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The reader parses log lines with `JSON.parse` and never evaluates them | `ravintio-zero/scripts/initiative-watch.mjs` | Low | Parse errors are caught and the line is skipped |
| An activity line can show the first line of a tool input, such as a command | `ravintio-zero/scripts/initiative-watch.mjs` | Low | Risk R-002. Tool results are never printed, control characters are removed, and the line stops at 200 characters |
| The watcher opens the step log for reading | `ravintio-zero/scripts/initiative-watch.mjs` | Low | It calls `refuseLinks` on the path first, as for every other file it reads. It writes no file |
| The driver output and log permissions are unchanged | `ravintio-zero/scripts/initiative-run.mjs` | Low | Test checks the log mode is 600 and driver output holds no step content |

No credentials, network calls, or new dependencies. No hook changed. Overall risk: low. Critical and high findings: 0. Risk register R-001 to R-004 stay open or accepted at low or medium.
