# Changelog (0000240-stream-step-session-activity, 28 Oct 2026)

**Feature:** Stream step session activity
**Version:** 0.31.0
**PR:** pending

## What changed

- `initiative-run.mjs` starts each step with `--output-format stream-json --verbose`. The step log now holds one JSON event per line.
- `initiative-watch.mjs` reads new bytes of the current step log and prints one `I-C Run: activity:` line per tool call, subagent start, and assistant text. Each line is 200 characters or fewer.
- The watcher polls every 10 seconds, down from 30.
- The initiative skill relays each activity line. The roadmap standards describe the stream log.
- Two new suites cover the driver and the watcher. Four existing suites update their expected `claude` arguments and the poll constant.

## Why

The human could not see a step build while it ran. The log stayed empty until the step ended, and the watcher saw only build log lines and commits.

## Deviations

- The TDD loop ran inline, without test-writer and implementer subagents. The units were small and shared one watcher file.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
