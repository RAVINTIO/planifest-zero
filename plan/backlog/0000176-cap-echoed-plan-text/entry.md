---
title: "Backlog Entry: 0000176 - cap plan text that the ratchet and consistency check print"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000176 - cap plan text that the ratchet and consistency check print

**Source feature:** 0000170-story-mapping-and-gherkin
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-25

---

## Problem

The 0000170 security review rated two findings low. `ratchet-check.mjs` prints each removed line in full when it blocks an edit, with no length cap. The step-line guard widens this to `Given`, `When`, and `Then` lines. `consistency-check.mjs` echoes a whole story map row label in a finding, also with no cap. A long or hostile line reaches the agent's context unchanged.

## Suggested Action

Truncate each printed line to a fixed length, such as 200 characters, and mark the cut. Add a test for each program with a line over the cap.

## Wanted outcome

`ratchet-check.mjs` and `consistency-check.mjs` each print at most 200 characters of an echoed line and mark the cut. One test per program feeds a line over the cap and checks the output.

## Why Deferred

Both findings are low, and both files belong to the plan owner. The fix touches output formats that other suites assert, so it needs its own run.
