---
title: "Backlog Entry: 0000309 - tests run with clean environment and repo state"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000309 - tests run with clean environment and repo state

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Tests leak state in both directions:

- Suites inherited `RAVINTIO_INITIATIVE_STEP=1` from a step session and failed (`plan/retrospectives/0000208-refresh-setup-record-2026-10-27.md`, `0000218-strict-hook-follows-active-skill-2026-10-27.md`).
- Nested runners inherited `RAVINTIO_TEST_QUIET=1`, and a test failed in a quiet full run (`0000251-driver-step-fixes-2026-10-28.md`).
- A test run moved the real `plan/backlog/.next-id` from 0000214 to 0000217, and the run restored it by hand (`0000208-refresh-setup-record-2026-10-27.md`).

## Suggested Action

- Have the test runner clear every `RAVINTIO_*` variable before each suite. A suite that needs one sets it itself.
- Make any test that writes repo state, such as `.next-id`, `plan/`, or `.claude/`, work on a temporary copy.
- Add a final runner check that fails when the working tree differs before and after the run.

## Wanted outcome

Tests give the same result in any session and leave the repo as they found it. Tests check these conditions:

- With `RAVINTIO_INITIATIVE_STEP=1` set in the session, the suite passes as it does without it.
- After a full run, `git status` matches the status before it.

## Why Deferred

The human asked for it on 2026-10-31, from the retrospectives of 0000208, 0000218, and 0000251. No run is active.
