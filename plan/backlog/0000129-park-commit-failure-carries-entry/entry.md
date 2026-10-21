---
title: "Backlog Entry: 0000129 - a failed chore commit in park.mjs can carry the entry file back to the feature branch"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P1."
status: "open"
---
# Backlog Entry: 0000129 - a failed chore commit in park.mjs can carry the entry file back to the feature branch

**Source feature:** 0000040-setup-json-checks-and-park
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-21

---

## Problem

`park.mjs` writes the parked entry on the chore branch, then runs `git add` and `git commit`. If either local step fails, the script checks out the feature branch again. The staged entry file can come along with that checkout. Push and `gh` failures do not hit this path.

## Suggested Action

On a local add or commit failure, run `git reset` and remove the written entry before the checkout. Add a suite case that forces a commit failure, for example with a failing `pre-commit` hook.

## Why Deferred

Local add and commit failures are rare. The entry file holds no secret, and the human sees the exact error.
