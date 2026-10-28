---
title: "Backlog Entry: step-log-trips-stale-cite-guard - Two suites fail in a step session because the phase guard reads the git-ignored step log."
summary: "In a step session, `test-0000042-req-006` and `test-0000043-req-009` fail. The phase guard scans `plan/.initiative-logs/step-7.log`, which is git-ignored and holds the step's own test output, including planted stale cites. Both suites pass on a clean archive of `HEAD`."
status: "open"
---
# Backlog Entry: step-log-trips-stale-cite-guard - Two suites fail in a step session because the phase guard reads the git-ignored step log.

**Source feature:** 0000245-boot-rules-into-skills
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

Make the guard skip `plan/.initiative-logs/`, or scan tracked files only.

## Suggested Action

- Both suites pass inside a step session with a populated step log.
- A planted stale cite in a tracked skill still fails the guard.

## Wanted outcome



## Why Deferred

Found while shipping 0000245. The fix is outside that feature. Source retrospective: `plan/retrospectives/0000245-boot-rules-into-skills-2026-10-28.md`.
