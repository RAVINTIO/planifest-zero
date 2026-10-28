---
title: "Verification Report - 0000241-watcher-false-events"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000241-watcher-false-events

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000241-watcher-false-events

Started: no service. The watcher runs as `node ravintio-zero/scripts/initiative-watch.mjs --once` against temporary git repos built by `test-0000241-req-001-watcher-false-events.sh`, and once against this working tree.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 | CLI, commit 5 seconds newer, clock 20 minutes on | verified | 0 stale lines, exit 0 |
| REQ-001 AC-2 | CLI, commit 20 minutes newer | verified | 1 stale line |
| REQ-002 AC-1 | CLI, `--passes 3` | verified | 1 stale line across 3 passes |
| REQ-002 AC-2 | CLI, new process | verified | stale line printed again |
| REQ-003 AC-1 | CLI, last-seen commit on another branch, 100 commits on HEAD | verified | 1 branch-change line, 0 commit lines |
| REQ-003 AC-2 | CLI, ancestor last-seen commit | verified | 2 commit lines for 2 new commits |
| REQ-004 AC-1 | CLI, lock file removed | verified | heartbeat says `lock free` |
| REQ-004 AC-2 | CLI, lock file present | verified | heartbeat says `lock held` |

A run against this tree with `--since-commit deadbeef --passes 2` printed one `branch changed to` line and two heartbeats, exit 0.
