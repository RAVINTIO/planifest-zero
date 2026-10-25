---
title: "Backlog Entry: 0000167 - release tags land on feature-branch commits, not main"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000167 - release tags land on feature-branch commits, not main

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

Ship tags the release on the feature branch before the PR merges. The human squash-merges each PR, so the tagged commit never reaches `main`. A tag then names a commit that `git log main` does not show.

On 2026-10-25 the human moved `v0.12.0` to `5b62e0b` and `v0.13.0` to `e0f9b2e`, the squash commits of PRs #25 and #27. `v0.1.0` to `v0.11.0` still sit on feature-branch commits.

## Suggested Action

Tag after the merge instead of before it. One option is a post-merge step, run after the human reports the merge, that tags the squash commit on `main` and pushes the tag. Another is a CI job on `push` to `main` that reads the version from `product.yml` and tags the merge commit. Update `ravintio-ship` Steps 7 and 9 and the roadmap R-D Advance stage to match. Decide whether to move `v0.1.0` to `v0.11.0` onto their squash commits too.

## Why Deferred

The human raised it after 0000164 merged. It changes the ship skill and possibly CI, so it needs its own design.
