---
title: "Requirement: req-008 - roadmap-delivery"
summary: "After the last step, ship archives the roadmap and raises one PR to main that asks for a merge commit."
status: "draft"
version: "0.1.0"
---
# Requirement: req-008 - roadmap-delivery

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-006
**Priority:** must-have

## User Story

As a human on the loop, I receive one roadmap PR to `main`, so that I review and merge the whole chain once.

## Functional Requirements
- After the last step merges, the agent runs the `R-E Delivery:` stage on the roadmap branch.
- The agent moves `plan/current-roadmap/` to `plan/_archive/{id}-{slug}-roadmap-{date}/` and sets the roadmap `status` to `done`.
  - The agent commits the move on the roadmap branch.
- The agent raises one PR from `roadmap/{id}-{slug}` to `main`.
- The PR body asks the human for a merge commit, not a squash.
  - The body lists each step with its version and tag.
- The agent never merges this PR and never commits to `main`.

## Acceptance Criteria
- [ ] (a) The ship skill requires the move of `plan/current-roadmap/` to `plan/_archive/{id}-{slug}-roadmap-{date}/` and sets `status: done`, on the roadmap branch.
- [ ] (b) The ship skill requires one PR from `roadmap/{id}-{slug}` to `main`, with a body that asks for a merge commit and lists each step with its version and tag.
- [ ] (c) The ship skill states that the agent never merges the roadmap PR and never commits to `main`.

## Dependencies
- REQ-005 supplies the per-step version and tag that the PR body lists.
- The roadmap file format and `done` status come from the roadmap activate requirement in this feature.
- Tests go in `planifest-zero/tests/test-0000043-req-008-roadmap-delivery.sh` (new), using the grep helpers in `planifest-zero/tests/helpers/assert.sh`.
- Files in reach:
  - `planifest-zero/skills/planifest-ship/SKILL.md` (Hard Limit 5 and the Step 4 and Step 8 text)
  - `.claude/skills/planifest-ship/SKILL.md` (installed copy, refreshed by setup)
  - `planifest-zero/pipeline-reference.md` (Ship Phase section)
