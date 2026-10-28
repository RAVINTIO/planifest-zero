---
title: "Retrospective: 2026-10-28 - boot rules into skills"
summary: "A blameless review of step 7 of initiative 0000238."
status: "open"
---
# Retrospective: 2026-10-28 - boot rules into skills

**Mode:** run
**Subject:** 0000245-boot-rules-into-skills
**Date:** 2026-10-28

## Summary

The generated `CLAUDE.md` fell from 10,317 to 4,701 bytes with every override still in force. The step ran with no stop and 5 test rework cycles.

## What helped

- Two subagents built the hook reference and the targeted override setup in parallel, in disjoint files (build log P2 notes).
- A temporary-project run of `setup.sh` proved the 6,000 byte cap against the real overrides (`ravintio-zero/tests/test-0000245-req-003-004-repo-skills-and-size-cap.sh`).

## What slowed the work

- `gate-write` blocked the first subagent write because `design.md` had no `## Component Paths` section (build log `Deviation:` line).
- Four suites read boot text that moved to the reference file and failed (build log `Rework:` line).
- The step log made two guard suites fail in the working tree only (`verification-report.md`).
- `.claude/skills/` was emptied during the step, with no known cause (backlog entry 0000262).

## Keep

- Move text verbatim and update each reading test to the new location in the same step (build log `Rework:` line).

## Change

- Write `## Component Paths` into the design at P0, so P2 subagents are not blocked (`plan/backlog/0000263 0000264 -component-paths-in-design-template/entry.md`).
- Keep the step log out of the stale cite guard (`plan/backlog/-step-log-trips-stale-cite-guard/entry.md`).
- Find what empties `.claude/skills/` (`plan/backlog/0000262-find-what-empties-installed-skills/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Component Paths in the design template | pack maintainer | `plan/backlog/0000263 0000264 -component-paths-in-design-template/entry.md` | review of the entry's Wanted outcome | 0000263 0000264  |
| Step log and the stale cite guard | pack maintainer | `plan/backlog/-step-log-trips-stale-cite-guard/entry.md` | step 8 tests |  |
| Find what empties installed skills | pack maintainer | `plan/backlog/0000262-find-what-empties-installed-skills/entry.md` | review of the entry's Wanted outcome | 0000262 |
