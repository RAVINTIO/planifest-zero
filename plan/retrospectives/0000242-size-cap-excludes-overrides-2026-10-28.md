---
title: "Retrospective: 2026-10-28 - size cap excludes overrides"
summary: "A blameless review of step 4 of initiative 0000238."
status: "open"
---
# Retrospective: 2026-10-28 - size cap excludes overrides

**Mode:** run
**Subject:** 0000242-size-cap-excludes-overrides
**Date:** 2026-10-28

## Summary

The size cap test now measures pack content only, with a 32,800 byte cap. The work was one test file and took one pass, plus a five hour stop on a failure outside the step.

## What helped

- The pack-only measure had a mutation check that proves growth still fails (`fc84aaf`).
- The chart decision on unsetting `RAVINTIO_INITIATIVE_STEP` avoided a false hook failure (build log, P3 note).

## What slowed the work

- A wording failure in backlog entry 0000257 stopped P2 for about five hours (build log `Blocked:` and `Resolved:` lines).

## Keep

- Measure what the pack ships and exclude what a consumer appends (`fc84aaf`).

## Change

- Test backlog entry wording at filing, not when a later step runs the suite (build log `Blocked:` line).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Run the wording test at filing | pack maintainer | `plan/backlog/0000260-test-backlog-prose-at-filing/entry.md` | review of the filing flow | 0000260 |
