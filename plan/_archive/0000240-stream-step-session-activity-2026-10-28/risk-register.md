---
title: "Risk Register - stream step session activity"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - stream step session activity

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Version:** 0.31.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A later Claude Code release changes the stream-json event shape and the reader prints nothing | medium | low | Skip unknown shapes. The raw stream stays in the log | open |
| R-002 | security | Activity lines expose file content from a tool input, such as a Bash command holding a secret | low | medium | Print only the first line of one input field, cut to 200 characters. Never print tool results. The human's chat already shows the same tool calls | open |
| R-003 | operational | The skill addition breaks the 1,720-line cap, which has 35 lines of headroom | medium | medium | Limit the addition to 6 lines. The cap test runs in P2 | open |
| R-004 | technical | A restarted watcher misses events written while it was down | medium | low | It starts at the end of the log by design. The log keeps the full stream | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | stream-json emits one JSON object per line, with tool calls as `tool_use` items in `assistant` events | The reader prints nothing for that shape | open |
| A-002 | The subagent tool is named `Task` or `Agent` | A subagent start prints as a plain `tool:` line | open |
