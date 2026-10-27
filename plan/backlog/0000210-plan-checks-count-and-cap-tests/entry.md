---
title: "Backlog Entry: 0000210 - plan checks the count, budget, cap, and entry-id tests"
summary: "A change filed by the retrospective of run 0000204, for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000210 - plan checks the count, budget, cap, and entry-id tests

**Source feature:** 0000204-run-and-initiative-retrospectives
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

Source retrospective: `plan/retrospectives/0000204-run-and-initiative-retrospectives-2026-10-27.md`.

Run 0000204 hit three rework loops that a P1 check would have prevented. An edit to the orchestrator skill passed the 27,700 byte cap in `test-0000151-req-011`. Adding a skill changed the skill count and the skill-text budget in `test-0000031` (two suites), `test-0000160`, and `test-0000203`. Pulling in entry 0000178 broke `test-0000189-req-008`. The plan named none of these tests, and each rework cost a full test run.

## Suggested Action

Add a step to `ravintio-plan` that greps the tests for the skill count, the skill-text budget, the size caps on edited skills, and the ids of pulled-in backlog entries. The step lists every matching test in the execution plan's unit that edits the file. A plan test reads the skill text and checks the step.

## Wanted outcome

An execution plan that adds a skill, edits the orchestrator skill, or pulls in a backlog entry names each test that holds the count, the budget, the cap, or the entry id. A run that does so ends with no rework loop for those causes.

## Why Deferred

The retrospective found it after the plan was written. It needs its own plan change and test.
