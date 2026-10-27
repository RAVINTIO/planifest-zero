---
title: "Backlog Entry: 0000211 - a missing assert helper lets a suite pass"
summary: "A test that calls an undefined assert function prints an error and still reports success."
status: "open"
---
# Backlog Entry: 0000211 - a missing assert helper lets a suite pass

**Source feature:** 0000205-initiative-skill
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

`ravintio-zero/tests/helpers/assert.sh` defines `assert_equals`, `assert_contains`, `assert_exit_zero`, and `print_summary`. It defines no `assert_not_contains`. During 0000205, a suite called `assert_not_contains`. Bash printed `command not found` and the suite still ended with `Results: 7 passed, 0 failed`. A negative check ran as no check at all. The source retrospective is `plan/retrospectives/0000205-initiative-skill-2026-10-27.md`.

## Suggested Action

Add an `assert_not_contains` helper. Also make the helpers count a call to an undefined `assert_*` function as a failure, for example with a `command_not_found_handle` that records a failure for `assert_*` names.

## Wanted outcome

A suite that calls an undefined assert function fails. A test checks this with a temporary suite that calls `assert_not_contains` before the helper exists in a fixture copy, and expects a non-zero exit.

## Why Deferred

It changes the shared test helper, which every suite loads. It needs its own run and a review of the helper's callers.
