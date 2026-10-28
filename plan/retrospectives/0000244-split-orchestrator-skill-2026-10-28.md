---
title: "Retrospective: 2026-10-28 - split the orchestrator skill"
summary: "A blameless review of step 6 of initiative 0000238."
status: "open"
---
# Retrospective: 2026-10-28 - split the orchestrator skill

**Mode:** run
**Subject:** 0000244-split-orchestrator-skill
**Date:** 2026-10-28

## Summary

The orchestrator `SKILL.md` fell from 23,912 to 7,985 bytes with no line lost. The step ran in one pass with no stop and two rework cycles.

## What helped

- The no-lost-line check in `ravintio-zero/tests/test-0000151-req-011-orchestrator-references-split.sh` proved each move against the base fixture and told the mover which line was missing.
- The `orch_combined` helper in `ravintio-zero/tests/helpers/assert.sh` already existed, so 21 suites needed a one-line change each.

## What slowed the work

- 29 feature suites and 3 regression suites read moved text from `SKILL.md` and failed after the move (build log `Rework:` lines).
- A forced `git add` of `plan/` committed driver logs and ack files. A later commit untracked them (build log `Rework:` lines).

## Keep

- Moving sections verbatim and checking them against a fixture, as in this step.

## Change

- Tests read orchestrator text through one helper, so a section move fails no test (`plan/backlog/0000261-tests-locate-text-through-one-helper/entry.md` already covers this).
- A step session stages artifacts by path and never force-adds `plan/` (`plan/backlog/0000213-stage-run-files-by-path/entry.md` already covers this and sits in step 9).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Locate orchestrator text through one helper | pack maintainer | `plan/backlog/0000261-tests-locate-text-through-one-helper/entry.md` | review of the entry's Wanted outcome | 0000261 |
| Stage run files by path | pack maintainer | `plan/backlog/0000213-stage-run-files-by-path/entry.md` | step 9 tests | 0000213 |
