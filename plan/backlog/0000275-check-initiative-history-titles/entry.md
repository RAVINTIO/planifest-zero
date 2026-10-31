---
title: "Backlog Entry: 0000275 - check the initiative history before it reaches main"
summary: "A postmortem action, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000275 - check the initiative history before it reaches main

**Source feature:** none (initiative 0000238 postmortems)
**Source phase:** none (human request)
**Deferral source:** postmortem `plan/postmortems/2026-10-31-initiative-history-has-untitled-commits.md`
**Date filed:** 2026-10-31

---

## Problem

Nothing reads the first-parent titles of an initiative branch. PR #72 and PR #74 each carried 23 direct commits to `main`, and no check flagged them. PR #72 also landed as a squash, which removed the step history from `main` until the human reset `main` and raised PR #74.

## Suggested Action

- Add a script that lists the first-parent commits of `initiative/*` since its base on `main`. It fails when a title doesn't match `{7-digit id}-{slug}: {summary} (#{n})`.
- Run it in CI on every PR from `initiative/*` to `main`.
- Run it at I-E Delivery before the PR is raised, and report each failing commit.
- Put the merge commit instruction in the PR title as well as the body, so the human sees it on the landing button.

## Wanted outcome

An initiative PR with an untitled first-parent commit fails before it reaches `main`. Tests check these conditions:

- The script passes a history of titled squashes only.
- The script fails a history with one direct commit and names that commit.
- CI runs the script on PRs from `initiative/*` to `main`.

## Why Deferred

The postmortem found it after initiative 0000238 was delivered. No run is active.
