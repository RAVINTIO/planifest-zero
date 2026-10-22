---
title: "Requirement: req-004 - park-local-failure-cleanup"
summary: "Park removes the written entry and unstages it when the local add or chore commit fails, then returns the human to a clean feature branch."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - park-local-failure-cleanup

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Source:** US-004 (backlog 0000129)
**Priority:** should-have

## User Story

As a human on the loop, I return to a clean feature branch when park's local add or commit fails, so that the parked entry never leaks into the feature branch.

## Functional Requirements
- In `finishPr` in `park.mjs`, if `git add` or the chore commit fails, park cleans up before it rethrows.
- The cleanup runs two steps in order:
  1. Run `git reset -q -- {entry}` to unstage the entry.
  2. Delete the entry file that park wrote.
- After the cleanup, `finishPr` rethrows the original error. `onFeatureBranch` then returns the working tree to the feature branch.
- The cleanup never throws over the original error and never replaces it. If a cleanup step fails, park ignores that failure and rethrows the original error.
- The human sees the exact git error, and the script exits non-zero.
- `park.md` stays committed on the feature branch. The cleanup touches only the entry path.
- Park's push and `gh` failure paths are out of scope and stay unchanged.
- Park never merges a pull request, never commits to `main`, and never force-pushes.
- The source of truth is `planifest-zero/skills/`. Setup refreshes the copy under `.claude/skills/`.

## Acceptance Criteria
- [ ] With a failing `pre-commit` hook in a temporary repo, park exits non-zero and prints the git error.
- [ ] After that failure, the working tree is on the feature branch.
- [ ] After that failure, the working tree holds neither the entry file nor a staged change.
- [ ] After that failure, `park.md` is still committed on the feature branch.
- [ ] A failure in the cleanup itself leaves the original error as the one park reports.
- [ ] Push and `gh` failure behaviour matches the existing park tests, which still pass.

## Dependencies
- Feature 0000040 req-004, which introduced `park.mjs`, `finishPr`, and `onFeatureBranch`.
- The existing park test suite at `planifest-zero/tests/test-0000040-req-004-005-park.sh`, which runs `park.mjs` against a local bare remote with a stub `gh`.
- Custom rule 001 permits push and `gh pr create` without asking. Merge stays human-only.
