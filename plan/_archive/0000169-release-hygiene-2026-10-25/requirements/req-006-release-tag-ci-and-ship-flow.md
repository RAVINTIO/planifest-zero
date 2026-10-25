---
title: "Requirement: REQ-006 - release-tag-ci-and-ship-flow"
summary: "CI tags the merge commit on main, and the ship flow and docs describe it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - release-tag-ci-and-ship-flow

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Source:** US-003 (backlog 0000167)
**Priority:** must-have

## User Story

As a maintainer, I see every release tag on a commit that `git log main` shows, so that a tag always names shipped code.

## Functional Requirements
- Today ship Step 7 creates `v{version}` on the feature branch, and Step 9 pushes it with the branch. A squash merge leaves that commit off `main`.
- Both `.github/workflows/ravintio.yml` and the template `ravintio-zero/hooks/ravintio.yml` add a `push` trigger on `main` and `master`.
- Both files add a `release-tag` job that runs only on `push`. It has `permissions: contents: write` on that job only.
- The `release-tag` job checks out with `fetch-depth: 0`, sets a bot git identity, and runs `node ravintio-zero/scripts/release-tag.mjs`.
- Every existing job gets `if: github.event_name == 'pull_request'` and keeps `contents: read`.
- Ship Step 7 no longer creates a tag.
- Ship Steps 9 and 10 say that CI tags the merge commit on `main` after the human merges.
- In the local-git-only case, ship prints the tag command for the human to run on the merge commit.
- The Ship stages paragraph in `ravintio-zero/standards/roadmap-standards.md` that names Step 7, `ravintio-zero/pipeline-reference.md`, and `ravintio-overrides/instructions/custom-004-ship-push-and-raise-pr.md` match this flow.
- Roadmap R-D Advance keeps tagging the squash commit as it does today.

## Acceptance Criteria
- [ ] Both workflow files parse as YAML, trigger on `push` to `main` and `master`, and hold a `release-tag` job with `contents: write`, `fetch-depth: 0`, a bot identity, and the `release-tag.mjs` command. Every other job has the `pull_request` guard and no write permission.
- [ ] Ship Step 7 holds no `git tag` command. Steps 9 and 10 name CI tagging on `main`, and the local-git-only case prints the tag command.
- [ ] `roadmap-standards.md`, `pipeline-reference.md`, and `custom-004` agree with the ship skill, and R-D Advance still tags the squash commit.

## Dependencies
- REQ-005 provides `release-tag.mjs`.
