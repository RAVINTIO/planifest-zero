---
title: "Retrospective: 2026-10-27 - chart-time decisions"
summary: "A blameless review of the chart-time decisions run, and the changes it files."
status: "open"
---
# Retrospective: 2026-10-27 - chart-time decisions

**Mode:** run
**Subject:** 0000206-chart-time-decisions
**Date:** 2026-10-27

## Summary

The run added the Chart-time decisions rules, three template tables, and the step-side rule. One size-cap rework occurred and the run raised no stop.

## What helped

- The plan split the work into a standards unit and a step unit, so the tests mapped to the requirements one to one (`plan/_archive/0000206-chart-time-decisions-2026-10-27/execution-plan.md`).
- Putting the rules in the standards file and one line in each skill kept the skill text under budget (`ravintio-zero/tests/test-0000206-req-002-step-application.sh`).

## What slowed the work

- The orchestrator skill passed its byte cap after the first edit, and the failure showed only in the full suite (`Rework: REQ-002` in the archived build log).
- The installed-copies check fails in every step of the initiative and needs a note each time (`plan/_archive/0000206-chart-time-decisions-2026-10-27/acceptance-evidence.md`).

## Keep

- Write the failing tests first, then the text. The first run of both suites failed on all assertions, which showed that the tests read the right sections (`ravintio-zero/tests/test-0000206-req-001-chart-rules.sh`).

## Change

- Skip the installed-copies check during an active initiative, so P3 reports only new failures (`plan/backlog/0000212-installed-copies-test-lags-pack/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Skip the installed-copies check during an active initiative | pack tests | `ravintio-zero/tests/test-0000151-req-014-chart-clarity-and-dependency-stop.sh` | A step of an active initiative runs the suite with no failure | `plan/backlog/0000212-installed-copies-test-lags-pack/entry.md` names this retrospective |
