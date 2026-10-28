# Changelog (0000241-watcher-false-events, 28 Oct 2026)

**Feature:** Watcher false events
**Version:** 0.31.1
**PR:** #58

## What changed

- The watcher prints a stale line only when a commit is at least 15 minutes newer than the last build log write.
- It prints each stale state once. A new process starts with no stale state.
- It lists new commits with `git log {last-seen}..HEAD` when the last-seen commit is an ancestor of `HEAD`. Otherwise it prints one `branch changed to {branch}` line.
- A new `--passes <n>` test aid runs several passes with `--once`.
- A new suite covers the four conditions of backlog entry 0000216. The 0000205 stale test moves its commit from 00:10 to 00:16.

## Why

During initiative 0000195 step 13 the watcher repeated a stale warning, reported old commits as new after a branch switch, and sent noise the human could not tell from progress.

## Deviations

- The TDD loop ran inline, without subagents, because one watcher file holds every change.
- The heartbeat already read the lock file on each pass, so REQ-004 needed a test and no code.
- REQ-002 AC-2 became a restart check, because `--once` cannot add a commit between passes.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
