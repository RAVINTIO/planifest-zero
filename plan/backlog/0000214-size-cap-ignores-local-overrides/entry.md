---
title: "Backlog Entry: 0000214 - the size cap test counts repo-local overrides"
summary: "test-0000151 req-011 sums the repo CLAUDE.md, so each local override can break a pack test."
status: "open"
---
# Backlog Entry: 0000214 - the size cap test counts repo-local overrides

**Source feature:** 0000208-refresh-setup-record
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

`ravintio-zero/tests/test-0000151-req-011-orchestrator-references-split.sh` adds the byte size of the repo `CLAUDE.md` to `SKILL.md` and caps the sum. `CLAUDE.md` includes every file in `ravintio-overrides/instructions/`, so adding an override raised the sum to 38,096 bytes and failed the test. Step 13 of initiative 0000195 raised the cap to 38,200. The source retrospective is `plan/retrospectives/0000208-refresh-setup-record-2026-10-27.md`.

## Suggested Action

Measure the boot template output without overrides, so the cap covers pack content only. Revert the cap to the pack-only figure.

## Wanted outcome

Adding an override file never changes the result of the size cap test, and a pack change that grows the boot file or `SKILL.md` still fails it.

## Why Deferred

It changes a shared test and needs a decision on which template output the cap measures.
