---
title: "Retrospective: 2026-10-27 - strict hook follows active skill"
summary: "A blameless review of the step 15 run."
status: "open"
---
# Retrospective: 2026-10-27 - strict hook follows active skill

**Mode:** run
**Subject:** 0000218-strict-hook-follows-active-skill
**Date:** 2026-10-27

## Summary

Both prompt hooks now name the skill that owns the session, and `plan/.initiative-ack` is git-ignored. The run shipped as 0.30.1 with no rework loop and no stop.

## What helped

- The backlog entry listed six checks, so P0 turned them into acceptance criteria with no questions (`feature-brief.md` in the archive).
- One test helper that ran both hooks for each case caught the one place they differed, the empty `plan/current/` condition.

## What slowed the work

- The new suite failed at first because a step session sets `RAVINTIO_INITIATIVE_STEP=1` and the test inherited it (`build-log.md`, P2 deviation). The 0000205 suite had the same latent flaw.
- `git rm --cached` left the pulled-in backlog folder on disk, so P0 removed it by hand.

## Keep

- A table-driven check that compares both hooks in each case.

## Change

- Tests that run a hook should clear `RAVINTIO_INITIATIVE_STEP`. Add this to the test standards if it recurs.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Clear `RAVINTIO_INITIATIVE_STEP` in hook tests | pack maintainers | `ravintio-zero/tests/README.md` | a step-session run of the Bash runner with no hook-test failure | none, covered by this step's `env -u` fix in both hook suites |
