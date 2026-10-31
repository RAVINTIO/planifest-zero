---
title: "Retrospective: 2026-10-29 - backlog clearance two"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-10-29 - backlog clearance two

**Mode:** initiative
**Subject:** 0000238-backlog-clearance-two
**Date:** 2026-10-29

## Summary

Fifteen steps shipped 22 backlog entries and a setup refresh, from 0.30.2 to 0.40.1. Two stops needed the human. One was planned, and one came from a chart format change during the run.

## What helped

- The planned driver restart after step 3 let steps 4 to 15 use the step 2 and step 3 driver changes (`## Decisions` row for step 3 in the archived `initiative.md`).
- Chart-time decisions settled known forks without a stop. Examples are the plain merge command and the rerun with `RAVINTIO_INITIATIVE_STEP` unset (`## Decisions` in the archived `initiative.md`).
- Step sessions streamed their activity to the coordinator from step 4 on, so each stop was found within minutes (`plan/.initiative-logs/step-4.log` onwards).
- Step 15 ran the suite in a clean clone, which separated real failures from session-only ones (`plan/.initiative-logs/step-15.log`, 00:36 UTC).

## What slowed the work

- Step 6's push was denied because its first commit force-added driver logs. The coordinator rewrote the unpushed history with the human's approval (PR #61 body, "Supervision note").
- Step 15 stopped once, because step 14 added a P1 skips table that the active plan lacked (`plan/.initiative-logs/step-15.attempt-1.log`, commit `8d0703d`).
- Step 15 ran the full suite six times to name three failures, which took about 45 minutes (`plan/.initiative-logs/step-15.log`, 00:15 to 00:59 UTC).
- Several build logs held typed times rather than clock times. Step 15 found and replaced its own (commit `b623f15`, backlog entry 0000266).
- Two log-sensitive tests failed in every live session and passed in a clean copy (backlog entry 0000264).

## Initiative questions

1. **Charted versus shipped.** All 15 charted steps shipped in charted order, with charted bumps. Versions ran 0.30.2 to 0.40.1 and every tag from `v0.30.2` to `v0.40.1` exists. Step 7 needed an extra PR (#63) to fix backlog folder names.
2. **Repeated friction.** Count and cap tests needed rework in most steps (`Rework:` lines in 12 of 15 archived build logs). Typed times recurred in steps 5, 8, 9, and 15. Some phase blocks had no `Complete:` line (steps 6, 7, and 9). The two log-sensitive tests failed in every live session.
3. **Stops and step times.** Step times come from PR open and merge times for steps 1 to 3, and from step log times for steps 4 to 15.

   | Step | Feature | Version | Time | Stop |
   |------|---------|---------|------|------|
   | 1 | 0000239-test-suite-reliability | 0.30.2 | PR merged 06:40 | none |
   | 2 | 0000240-stream-step-session-activity | 0.31.0 | PR merged 07:09 | none |
   | 3 | 0000241-watcher-false-events | 0.31.1 | PR merged 07:33 | planned driver restart. The human restarted at 13:13. |
   | 4 | 0000242-size-cap-excludes-overrides | 0.31.2 | 21 min | none |
   | 5 | 0000243-session-start-detection | 0.32.0 | 46 min | none |
   | 6 | 0000244-split-orchestrator-skill | 0.33.0 | 33 min | push denied. The coordinator rewrote history and shipped with the human's approval. Restart at 18:42. |
   | 7 | 0000245-boot-rules-into-skills | 0.34.0 | 56 min | none |
   | 8 | 0000246-plan-checks-count-and-cap-tests | 0.35.0 | 22 min | none |
   | 9 | 0000247-git-state-hygiene | 0.36.0 | 28 min | none |
   | 10 | 0000248-ship-merge-and-wall-clocks | 0.37.0 | 47 min | none |
   | 11 | 0000249-check-path-before-missing-claims | 0.38.0 | 19 min | none |
   | 12 | 0000250-initiative-mid-run-changes | 0.39.0 | 20 min | none |
   | 13 | 0000251-driver-step-fixes | 0.39.1 | 21 min | none |
   | 14 | 0000252-chart-rules | 0.40.0 | 21 min | none |
   | 15 | 0000253-refresh-setup | 0.40.1 | 60 min | no P1 skip table. The coordinator converted the chart notes with the human's approval. Restart at 00:06. |

4. **Tooling gaps.**
   - The watcher raised a false stale event before step 15 wrote its build log. It also reported "step 16" while step 15 waited for CI (backlog entry 0000270).
   - `gate-write` covers the Write and Edit tools only, so shell writes skip it (backlog entry 0000271).
   - `run-tests.sh` names no failing suite (backlog entry 0000269).
   - A step session hid `plan/.initiative-logs/` for at least 10 minutes during step 9 (backlog entry 0000265).

## Evidence gaps

- `plan/postmortems/` doesn't exist. The stops at steps 4 and 6 have no postmortem.
- Step 3 (0000241) has no run retrospective in `plan/retrospectives/`.
- Steps 1 to 3 have no timestamps in their step logs, because streaming started at step 4.

## Keep

- Settle known forks at chart as `## Decisions` rows, so steps apply them without a stop (archived `initiative.md`).
- Rerun suspect tests in a clean clone before treating a failure as real (`plan/.initiative-logs/step-15.log`).

## Change

- A step that changes a chart format updates the active `initiative.md` in the same step (backlog entry 0000268).
- The test runner names every failed suite (backlog entry 0000269).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Migrate the active plan when a chart format changes | plan skill | `ravintio-zero/skills/ravintio-plan/` | test on the plan skill text | backlog entry 0000268 |
| List failed suites by name | test runner | `ravintio-zero/tests/run-tests.sh` | runner test with one failing suite | backlog entry 0000269 |
| Watcher waits for the build log and names the running step | watcher | `ravintio-zero/scripts/initiative-watch.mjs` | watcher tests | backlog entry 0000270 |
| Apply `gate-write` rules to shell writes | hooks | `ravintio-zero/hooks/` | hook tests, with every current block kept | backlog entry 0000271 |
| Clock times and closed phase blocks in build logs | phase skills, build log check | `ravintio-zero/scripts/build-log-check.mjs` | build log check tests | backlog entry 0000266 |
| Steps leave driver files in place | orchestrator skill | `ravintio-zero/skills/ravintio-orchestrator/` | skill text test | backlog entry 0000265 |
| Point `test-0000164-req-007` at the file that holds the rules | tests | `ravintio-zero/tests/` | the test itself | backlog entry 0000267 |
