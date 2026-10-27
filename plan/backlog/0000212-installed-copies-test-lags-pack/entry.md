---
title: "Backlog Entry: 0000212 - the installed-copies test fails in every step of an initiative"
summary: "test-0000151 req-014 compares .claude/skills with the pack, so it fails in each step until setup reruns."
status: "open"
---
# Backlog Entry: 0000212 - the installed-copies test fails in every step of an initiative

**Source feature:** 0000206-chart-time-decisions
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

`ravintio-zero/tests/test-0000151-req-014-chart-clarity-and-dependency-stop.sh` asserts that `.claude/skills/` matches `ravintio-zero/skills/`. `.claude/skills/` is git-ignored and changes only when setup runs. In an initiative, each step changes pack skills, so the test fails in each step's P3 and each acceptance evidence repeats the same note. The source retrospective is `plan/retrospectives/0000206-chart-time-decisions-2026-10-27.md`.

## Suggested Action

Skip the installed-copies assertion when `.claude/skills/.ravintio-manifest` is older than the newest pack skill and `plan/current-initiative/initiative.md` has `status: active`. Print a `SKIP` line that names the reason. Run the assertion in every other case.

## Wanted outcome

A step of an active initiative reports no failure from the installed-copies check, and a stale copy outside an initiative still fails the suite.

## Why Deferred

It changes a shared test and needs a decision on how a stale install should show in CI.
