---
title: "Backlog Entry: 0000278 - stop initiative PRs landing on main as a squash"
summary: "A postmortem action, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000278 - stop initiative PRs landing on main as a squash

**Source feature:** none (initiative 0000238 postmortems)
**Source phase:** none (human request)
**Deferral source:** postmortem `plan/postmortems/2026-10-31-initiative-history-has-untitled-commits.md`
**Date filed:** 2026-10-31

---

## Problem

PR #72 asked for a merge commit in its body, but it landed on `main` as squash `27da2a9`. The squash dropped the 38 initiative commits from the history of `main`, and `main` could no longer reach the step tags.

The fix needed two force-pushes to `main` and two replacement PRs, #74 and then #75 and #76. Nothing on GitHub stopped the squash, and nothing after it flagged the single-parent commit.

## Suggested Action

- Document a GitHub ruleset on `main` whose pull request rule allows only the merge commit method. Squash stays allowed on `initiative/**`, so step PRs still land as squashes. The human applies the ruleset, and the setup docs record it.
- Add a CI check on pushes to `main`. It fails when the newest commit came from an `initiative/*` PR and has one parent.
- Keep the merge commit instruction at the top of the initiative PR body, and add it to the title, as entry 0000275 suggests.

## Wanted outcome

An initiative PR can't land on `main` as a squash, or CI flags it at once. Tests check these conditions:

- The CI check fails on a single-parent commit from an `initiative/*` PR.
- The CI check passes on a two-parent commit.
- The setup docs name the repository setting.

## Why Deferred

The postmortem found it after initiative 0000238 was delivered. No run is active.
