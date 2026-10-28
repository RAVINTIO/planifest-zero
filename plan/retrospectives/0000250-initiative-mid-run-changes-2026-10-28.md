---
title: "Retrospective: 2026-10-28 - initiative mid-run changes"
summary: "A blameless review of step 12 of initiative 0000238."
status: "open"
---
# Retrospective: 2026-10-28 - initiative mid-run changes

**Mode:** run
**Subject:** 0000250-initiative-mid-run-changes
**Date:** 2026-10-28

## Summary

The driver now stops with `I-D Advance: Restart:` after a merged step that changed the driver, the watcher, or the initiative skill. The initiative skill also routes a mid-run repo instruction into step scope. The step ran with no stop and no rework cycle.

## What helped

- Both entries carried a Wanted outcome that mapped to test conditions, so P0 needed no clarification (`feature-brief.md`).
- The existing driver test in `test-0000205-req-001-driver-fixes.sh` gave a ready fixture and stub, so the new driver test took one pass (`verification-report.md`).
- Writing both tests first showed 11 and 10 failures, then full passes after the edits.

## What slowed the work

- The full suite took about 9 minutes and made up most of the P2 wall clock (`build-log.md`, P2 block).
- The step log failed the stale cite guard suites again (entry 0000264). Both suites pass on a clean archive of `HEAD`.
- I typed a build log time ahead of the clock in P0 and corrected it after P1 (`build-log.md`, commit "correct build log times"). Entry 0000266 already covers this.

## Keep

- Build driver tests on a stub `claude` in a temporary git repository. The test covers the stop, the restart, and the no-change case in one file (`test-0000250-req-002-driver-restart-stop.sh`).

## Change

- Read the clock for every build log time, and let a check catch a future time (entry 0000266, already filed).
- Fix the stale cite guard so a step log cannot fail it (entry 0000264, already filed).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Build log clock times | pack maintainer | `plan/backlog/0000266-build-log-real-times-and-phase-ends/entry.md` | the entry's Wanted outcome | 0000266 |
| Step log and the stale cite guard | pack maintainer | `plan/backlog/0000264-step-log-trips-stale-cite-guard/entry.md` | the entry's Wanted outcome | 0000264 |
