---
title: "Requirement: req-005 - parked-pickup"
summary: "Backlog pickup at P1 offers resume or discard for a parked entry, and resume detection finishes an interrupted park."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - parked-pickup

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Source:** US-005 (backlog 0000101)
**Priority:** must-have

## User Story

As a human on the loop, I pick up a parked entry at a later P1, so that I either resume the feature or discard its branch and never lose parked work silently.

## Functional Requirements
- At P1 backlog pickup, an entry with status `parked` offers resume or discard. It does not offer the pull-in, leave, discard choice for ordinary entries.
- Resume does these steps in order:
  1. Check out the branch the entry names.
  2. Merge `origin/main` into it.
  3. Restore state from `plan/current/park.md` the way resume detection restores state from `pause.md`.
  4. Delete the parked entry folder and `park.md` in one commit on the feature branch, as ordinary pull-in deletes its entry.
- Discard deletes the branch locally and on `origin`. It runs only after the human confirms. It then deletes the parked entry folder with a build-log note, as ordinary discard does.
- Resume detection gains a step for `park.md`. It applies when the session is still on the feature branch. If the file exists and `gh pr list --head chore/park-{feature-id} --state all` returns nothing, the orchestrator finishes the chore PR step of park (req-004 steps 3 to 5).
  - A failed push or `gh` call stops with the exact error, as in req-004.
- Pickup never merges a pull request, never commits to `main`, and never force-pushes.

## Acceptance Criteria
- [ ] The orchestrator skill backlog pickup step names the `parked` status and offers resume or discard for it.
- [ ] The skill states that resume checks out the branch, merges `origin/main`, and restores state from `park.md`.
- [ ] The skill states that discard deletes the branch locally and on `origin` only after the human confirms.
- [ ] The Resume Detection list has a step for `park.md` that finishes the chore PR when none exists.
- [ ] Against a test repo, resuming a parked entry leaves the working tree on the feature branch with `origin/main` merged and the recorded phase restored.
- [ ] Against a test repo, declining the discard confirmation leaves the branch in place locally and on `origin`.
- [ ] Against a test repo, confirming the discard removes the branch locally and on `origin`.

## Dependencies
- req-004 writes `park.md` and the `parked` entry that this requirement reads.
- Resume detection step 7 (pause restore) is the model for restoring from `park.md`.
