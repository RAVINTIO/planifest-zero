---
title: "Requirement: req-010 - merge-carve-out-governance"
summary: "Four governance texts keep merging into main human-only and add one narrow carve-out for squash merges into roadmap/*."
status: "draft"
version: "0.1.0"
---
# Requirement: req-010 - merge-carve-out-governance

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-008, US-005
**Priority:** must-have

## User Story

As a human on the loop, I want the governance text to allow one narrow agent merge, so that a green step lands on the roadmap branch while `main` stays human-only.

## Functional Requirements
- These four texts each keep "merge into `main` is human-only" and gain the same carve-out:
  - The "Merge is human-only" rule in `planifest-zero/skills/planifest-orchestrator/SKILL.md`.
  - The Git Permissions section of `CLAUDE.md`.
  - `planifest-overrides/instructions/custom-001-local-git-only.md`.
  - `planifest-overrides/instructions/custom-004-ship-push-and-raise-pr.md`.
- The carve-out lets the agent run `gh pr merge --squash` only when all of these hold:
  - The PR's base is `roadmap/*`.
  - The PR is for the agent's own feature branch.
  - P3 finished clean and CI is green.
- The final roadmap PR to `main` stays human-only.
  - The agent never merges it and never commits to `main`.
- Each text names `merge-guard` as the hook that enforces the carve-out.
- The four texts agree on the carve-out wording, so none contradicts another.
- Existing sentences outside the merge rules keep their current text.

## Acceptance Criteria
- [ ] (a) A grep test finds `roadmap/*`, `--squash`, and the clean-P3-and-green-CI condition in all four files.
- [ ] (b) A grep test finds in all four files that merging into `main` and the roadmap PR to `main` remain human-only.
- [ ] (c) A grep test finds `merge-guard` named in all four files, and the old unconditional text ("never merge a pull request" without a carve-out) is gone from the orchestrator rule.

## Dependencies
- REQ-006 supplies the `merge-guard` hook that enforces the carve-out.
- REQ-005 (roadmap-advance) is the step that runs the permitted merge.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (the "Merge is human-only" rule, near line 383)
  - `planifest-zero/skills/planifest-ship/SKILL.md` (Hard Limit 5, "Never merge a PR")
  - `CLAUDE.md` (the override block that setup regenerates from `planifest-overrides/instructions/`, so re-run setup rather than edit it by hand)
  - `planifest-overrides/instructions/custom-001-local-git-only.md`
  - `planifest-overrides/instructions/custom-004-ship-push-and-raise-pr.md`
  - `planifest-zero/tests/` (new governance grep test)
