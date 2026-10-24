---
title: "Requirement: req-001 - roadmap-drafts"
summary: "A human files a draft roadmap in plan/roadmap/ on any branch, using a new template and the backlog's shared id sequence."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - roadmap-drafts

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-001
**Priority:** must-have

## User Story

As a human on the loop, I file a draft roadmap in `plan/roadmap/` on any branch, so that long-term intent has a home.

## Functional Requirements
- A draft roadmap lives at `plan/roadmap/{id}-{slug}/roadmap.md`, one folder per draft.
- A new template, `planifest-zero/templates/roadmap-entry.template.md`, defines the file.
  - The frontmatter holds `title`, `summary`, and `status`.
  - The body holds the fields `goal`, `branch`, `status`, `position`, and stop conditions.
  - `status` takes `draft`, `active`, `blocked`, or `done`. A new draft starts at `draft`.
  - `position` names the next step to run.
  - The body ends with a step table with the columns `Step`, `Feature id`, `Backlog entries`, `Bump`, `Version`, and `Status`.
  - `Bump` takes `major`, `minor`, or `patch`, and `minor` is the default.
- Roadmap ids share the backlog's seven-digit sequence.
  - The next id is the highest id ever allocated plus one.
  - The high-water mark covers `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/`.
- Filing a draft has no message prefix.
  - It works on any branch and in any phase, as filing a backlog entry does.
  - The draft reaches `main` with the PR of the branch that holds it.
- The agent may suggest a draft and help the human structure it.
  - The agent writes the draft file only after the human confirms.

## Acceptance Criteria
- [ ] (a) `planifest-zero/templates/roadmap-entry.template.md` exists with the `title`, `summary`, and `status` frontmatter, the fields `goal`, `branch`, `status`, `position`, and stop conditions, the four `status` values, and the step table with its six columns.
- [ ] (b) The orchestrator skill states that roadmap ids share the backlog's seven-digit sequence, and that the high-water mark covers backlog, archive, changelog, and roadmap ids.
- [ ] (c) The orchestrator skill states that filing a draft roadmap has no prefix, works on any branch and in any phase, and that the agent writes the draft only after the human confirms.

## Dependencies
- Upstream: the backlog model in the orchestrator skill, which roadmap drafts mirror.
- REQ-002 picks up the drafts that this requirement files.
- Files in reach:
  - `planifest-zero/templates/roadmap-entry.template.md` (new)
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (owns the backlog id rule and the filing rules)
  - `planifest-zero/templates/backlog-entry.template.md` (the model to mirror, change nothing unless it states the id high-water mark)
  - `planifest-zero/pipeline-reference.md` (check for a template or folder listing that needs `plan/roadmap/`)
  - `.claude/skills/planifest-orchestrator/SKILL.md` (installed copy, refreshed by setup, not edited by hand)
  - `planifest-zero/tests/test-0000043-req-001-roadmap-drafts.sh` (new)
