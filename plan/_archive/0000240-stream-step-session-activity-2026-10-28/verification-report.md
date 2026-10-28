---
title: "Verification Report - 0000240-stream-step-session-activity"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000240-stream-step-session-activity

I started `initiative-watch.mjs` in a temporary git repo with a fixture initiative at position 2. I appended a stream-json `tool_use` event to the step log and stopped the watcher. The driver tests use a stub `claude` on `PATH`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| req-001 AC-1 | Ran the driver against a stub that records its arguments | verified | Arguments held `--output-format stream-json --verbose` and `Run initiative step 1` |
| req-001 AC-2 | Ran the driver and inspected the log | verified | Log held the stub's stream line and had mode 600 |
| req-002 AC-1 | Ran the watcher with `--since-bytes 0` on a log with four events | verified | Four activity lines in order, the last `agent: started` |
| req-002 AC-2 | Ran the watcher on invalid JSON, an unknown type, and a partial line | verified | No line for them, exit 0 |
| req-002 AC-3 | Read `POLL_MS` | verified | Equals 10000 |
| req-002 live | Ran the watcher in loop mode, then appended one event | verified | The activity line printed 9 seconds after the append |
| req-003 AC-1 | Ran the watcher on a 1,000 character command | verified | Longest line is 200 characters or fewer, prefix kept |
| req-003 AC-2 | Ran the watcher on a command with a newline | verified | One physical line per event |
| req-004 AC-1 | Ran the driver with a stub that prints a marker | verified | Driver output holds no marker |
| req-005 AC-1, AC-2 | Searched the skill and standards | verified | Both name `I-C Run: activity:`, the skill says to relay each line, the standards name `stream-json` |
| Real `claude` event shape | Not run: a live call would need a paid model run | not-verifiable | Assumption A-001 holds only for documented shapes. The reader skips unknown shapes and the log keeps the raw stream |
