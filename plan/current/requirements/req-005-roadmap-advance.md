---
title: "Requirement: req-005 - roadmap-advance"
summary: "Inside a roadmap step, P4 raises the PR against the roadmap branch, squash-merges it after green CI, and tags the squash commit."
status: "draft"
version: "0.1.0"
---
# Requirement: req-005 - roadmap-advance

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-005
**Priority:** must-have

## User Story

As a human on the loop, I let the agent squash-merge a green step into the roadmap branch and tag it, so that the next step builds on it.

## Functional Requirements
- Inside a roadmap step, P4 Ship runs the `R-D Advance:` stage.
  - The ship skill detects a roadmap step when `plan/current-roadmap/roadmap.md` has `status: active`.
- The PR targets the roadmap branch with `gh pr create --base roadmap/{id}-{slug}`.
- The same PR carries the roadmap update in `plan/current-roadmap/roadmap.md`.
  - The step's Status becomes `merged`.
  - The step's Version holds the released version.
  - `position` moves to the next step.
- The agent waits for CI with `gh pr checks`.
  - Red or pending CI is an exception stop. The agent logs `Blocked:`, pushes, and exits.
- On green CI, the agent runs `gh pr merge --squash`, then fetches.
- The agent tags the squash commit on the roadmap branch with the step's version, then pushes the tag.
- A normal run outside a roadmap keeps today's order. The tag comes before the PR, and the agent never merges.

## Acceptance Criteria
- [ ] (a) The ship skill states the roadmap-step PR command with `--base roadmap/{id}-{slug}` and requires the same PR to set the step to `merged`, fill Version, and move `position`.
- [ ] (b) The ship skill requires green `gh pr checks` before `gh pr merge --squash`, treats red or pending CI as a `Blocked:` stop, then fetches, tags the squash commit, and pushes the tag.
- [ ] (c) The ship skill keeps the tag-before-PR order and the no-merge rule for a run outside a roadmap.

## Dependencies
- The roadmap file format and `position` field come from the roadmap activate and resume requirements in this feature.
- merge-guard (REQ-006) must allow `gh pr merge --squash` for a `roadmap/*` base.
- The exception stops in the 0000042 run-mode ADR define the `Blocked:` format.
- Tests go in `planifest-zero/tests/test-0000043-req-005-roadmap-advance.sh` (new), using the grep helpers in `planifest-zero/tests/helpers/assert.sh`.
- Files in reach:
  - `planifest-zero/skills/planifest-ship/SKILL.md` (Hard Limits 4 and 5, Steps 6 to 8, and the Step 10 closing line)
  - `.claude/skills/planifest-ship/SKILL.md` (installed copy, refreshed by setup)
  - `planifest-zero/pipeline-reference.md` (Ship Phase section, step 3 on tag and PR)
