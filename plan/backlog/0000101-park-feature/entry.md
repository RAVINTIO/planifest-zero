---
title: "Backlog Entry: 0000101 - park a part-finished feature and unpick its progress"
summary: "A human-requested capability, filed for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000101 - park a part-finished feature and unpick its progress

**Source feature:** none (human request)
**Source phase:** none (outside a pipeline run)
**Deferral source:** human request
**Date filed:** 2026-10-16

---

## Problem

The pause command saves state so a run can resume at the same point. Nothing covers stopping a part-finished feature for the longer term and removing its changes. Today the human must revert commits, clear `plan/current/`, and remove sentinels by hand.

## Suggested Action

Add a park command. It does the following:

1. Snapshots `plan/current/` to an archive folder marked as parked, with a record of the phase reached.
2. Reverts the feature's code and doc changes on its branch, or leaves the branch unmerged and resets the working tree.
3. Clears the sentinels.
4. Files a backlog entry that points at the snapshot, so a later P0 can resume or restart the feature.

## Why Deferred

The human raised it as a new capability. It needs a design for how much to reverse, and how a parked feature resumes.
