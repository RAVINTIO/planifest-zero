---
title: "Backlog Entry: 0000144 - Ship clears sentinels after the PR is pushed"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000144 - Ship clears sentinels after the PR is pushed

**Source feature:** 0000042-autonomous-mode-and-prefixes
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-23

---

## Problem

In `planifest-zero/skills/planifest-ship/SKILL.md`, Step 8 pushes the branch and raises the PR. Step 9 then commits the deletion of `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode`. No step pushes that commit. The PR can therefore carry the sentinels, and a merge puts them on `main`. An autonomous run ends straight after Step 10, so nobody pushes the commit by hand.

Step 7 also says "Local only. Do not push the tag." The `custom-004-ship-push-and-raise-pr.md` override tells the agent to push the tag.

## Suggested Action

Clear the sentinels before Step 8, or push again after Step 9. Settle whether Step 7 pushes the tag when the agent raises the PR.

## Why Deferred

Feature 0000042 changes the run-mode gates, not the ship step order. The fix changes the ship sequence and the 0000023 marker lifecycle tests, so it needs its own decision.
