---
title: "Acceptance Evidence - 0000241-watcher-false-events"
summary: "Results for the PR description."
---
# Acceptance Evidence - 0000241-watcher-false-events

- Checks: consistency check clean. Script syntax check clean. Feature suites 204 passed, 0 failed. Regression suite 19 passed, 0 failed.
- Self-correction cycles: 0.
- Security: 0 critical, 0 high, 0 medium, 2 low (mitigated). Overall rating low.
- Execution: 8 of 8 acceptance criteria verified by running the watcher. 0 not-verifiable. See `plan/current/verification-report.md`.
- Criteria checked in `local`: all four conditions in backlog entry 0000216 pass with `--once` and `--passes`.
- Deviations: REQ-002 AC-2 became a restart check, because `--once` cannot add a commit between passes. The 0000205 stale test moved its commit from 00:10 to 00:16 for the 15 minute rule. REQ-004 needed no code, as the heartbeat already read the lock file on each pass.
