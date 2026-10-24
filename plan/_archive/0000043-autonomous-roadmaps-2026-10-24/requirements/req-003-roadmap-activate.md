---
title: "Requirement: req-003 - roadmap-activate"
summary: "R-B Activate checks preflight conditions, cuts the roadmap branch, writes the active roadmap in one commit, and offers to start the driver."
status: "draft"
version: "0.1.0"
---
# Requirement: req-003 - roadmap-activate

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-003
**Priority:** must-have

## User Story

As a human on the loop, I activate a charted roadmap, so that its branch and state exist and the driver can start.

## Functional Requirements
- R-B Activate runs these preflight checks before it changes anything:
  - A remote named `origin` exists.
  - `gh` access works.
  - No `roadmap/{id}-*` branch exists on `origin`.
- If a preflight check fails, Activate stops with a `Blocked:` message that names the failed check. It creates no branch and no file.
- Activate refuses when it would break the rule of one active roadmap per working tree.
  - The refusal message names the roadmap that is already active.
- When the checks pass, Activate cuts `roadmap/{id}-{slug}` from `main`.
- In one commit, Activate does both of these:
  - It writes `plan/current-roadmap/roadmap.md` with `status: active`.
  - It deletes the draft folder `plan/roadmap/{id}-{slug}/`.
- Activate pushes the roadmap branch to `origin`.
- After the push, Activate offers to start the driver `planifest-zero/scripts/roadmap-run.mjs` in the background.
  - A Claude session runs the driver as a background task, because a foreground Bash call times out after 10 minutes.
  - The offer tells the parent session not to edit the working tree while the driver runs.
- All Activate messages use the `R-B Activate:` prefix.

## Acceptance Criteria
- [ ] (a) The orchestrator skill lists the three R-B Activate preflight checks and the one-active-roadmap refusal, and each failure stops with a `Blocked:` message before any branch or file changes.
- [ ] (b) The orchestrator skill states that Activate cuts `roadmap/{id}-{slug}` from `main`, writes `plan/current-roadmap/roadmap.md` with `status: active`, deletes the draft folder in one commit, and pushes.
- [ ] (c) The orchestrator skill states that Activate offers to start `roadmap-run.mjs` as a background task and that the parent session must not edit the working tree while it runs.

## Dependencies
- REQ-001 supplies the draft folder `plan/roadmap/{id}-{slug}/` and the shared id sequence.
- REQ-002 supplies the charted roadmap that Activate takes as input.
- REQ-007 supplies `roadmap-run.mjs`, which Activate offers to start.
- REQ-009 supplies the `R-B Activate:` prefix in the prefix tables.
- A new test checks the criteria by grep: `planifest-zero/tests/test-0000043-req-003-roadmap-activate.sh` (new).
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (gains the R-B Activate stage)
  - `.claude/skills/planifest-orchestrator/SKILL.md` (installed copy, refreshed from the pack)
  - `planifest-zero/templates/` (a roadmap file template if REQ-001 adds one, otherwise unchanged)
  - `plan/roadmap/` and `plan/current-roadmap/` (new, created at run time and not in the pack)
