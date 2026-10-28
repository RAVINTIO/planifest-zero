---
title: "Feature Brief - test suite reliability"
summary: "Makes a call to an undefined assert helper fail the suite, and stops stale installed copies failing every initiative step."
status: "approved"
version: "0.1.0"
---
# Feature Brief - test suite reliability

**Feature ID:** 0000239-test-suite-reliability

## Business Goal

Two test faults give false results. A suite that calls an undefined `assert_*` function prints `command not found` and still passes. The installed-copies check in `test-0000151-req-014` fails in every initiative step, because `.claude/skills/` changes only when setup runs.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Undefined assert fails | As a maintainer, I see a suite fail when it calls an undefined `assert_*` function, so that a negative check never runs as no check. | must-have | 1 |
| Stale install skip | As a step session, I see no failure from a stale installed copy, so that acceptance evidence stays free of repeated notes. | must-have | 1 |

## Scope Boundaries

### In Scope
- Add `assert_not_contains` to `helpers/assert.sh`.
- Count a call to an undefined `assert_*` function as a failure in `print_summary`.
- Add a stale-install check to the helpers. Use it in `test-0000151-req-014` section (c).
- Mirror the new helpers in `helpers/assert.ps1` only if that file has matching helpers.
- Update docs that describe the helpers.

### Out of Scope
- Changing how setup installs skills.
- Other suites that call `assert_*` helpers.

### Deferred
- None.

## Acceptance Criteria

- [ ] AC-1: A suite that calls an undefined `assert_*` function exits non-zero.
- [ ] AC-2: `assert_not_contains` passes when the needle is absent and fails when it is present.
- [ ] AC-3: With an active initiative and a manifest older than the newest pack skill, the installed-copies check prints a `SKIP` line that names the reason and reports no failure.
- [ ] AC-4: Without an active initiative, a stale installed copy still fails the suite.
- [ ] AC-5: With an active initiative and a current manifest, a stale installed copy still fails the suite.

## Scope lock

- In: helper changes and the req-014 section (c) check. [source: draft-accepted (initiative)]
- Out: setup changes and other suites. [source: draft-accepted (initiative)]
- Deferred: none. [source: draft-accepted (initiative)]
- Assumption: a step session sets `plan/current-initiative/initiative.md` to `status: active`. [source: draft-accepted (initiative)]
