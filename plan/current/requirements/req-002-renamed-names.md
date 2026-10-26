---
title: "Requirement: req-002 - renamed names"
summary: "Every name for the charted unit uses its initiative form."
status: "draft"
version: "0.1.0"
---
# Requirement: req-002 - renamed names

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find the initiative under `initiative` names in paths, files, scripts, the branch pattern, env vars, logs, and telemetry, so that each name says what it holds.

## Functional Requirements
- Each row of the Names table in `design.md` uses its new form across the pack:
  - Branch pattern `initiative/{id}-{slug}`.
  - Active file `plan/current-initiative/initiative.md`, and draft file `plan/roadmap/{id}-{slug}/initiative.md`.
  - Scripts `initiative-run.mjs` and `initiative-labels.mjs`, and template `initiative.template.md`.
  - Step logs in `plan/.initiative-logs/`, with mode 700 for the folder and 600 for each log.
  - Variables `RAVINTIO_INITIATIVE_MODEL` and `RAVINTIO_INITIATIVE_MAX_TURNS`.
  - Telemetry labels `work.kind=initiative` and `ravintio.initiative={id}-{slug}`.
- `merge-guard` allows a squash merge only into an `initiative/*` base, and refuses a `roadmap/*` base.
- The CI workflow and its template run on pull requests to `initiative/**` and no longer list `roadmap/**`.
- I-B Activate moves the draft from `plan/roadmap/{id}-{slug}/initiative.md` to `plan/current-initiative/initiative.md`.
- Prose uses "initiative" for the charted unit in these places:
  - skills, standards, templates, and docs
  - `ravintio-overrides/instructions/`, including the merge exception in `custom-001` and `custom-004`
  - `CLAUDE.md`
- These names stay: `roadmap-standards.md`, the `ravintio.step` label, historical test file names, `plan/_archive/`, and `plan/changelog/`.
- Existing driver, `merge-guard`, CI, and label tests change to the new names. No test is removed.

## Acceptance Criteria
- [ ] AC-1: Driver uses new paths and labels
  - Given a stub active initiative at `plan/current-initiative/initiative.md`
  - When the driver test runs `initiative-run.mjs`
  - Then it reads that file, writes logs to `plan/.initiative-logs/`, and passes `work.kind=initiative` and `ravintio.initiative` labels
- [ ] AC-2: Merge guard uses the new base
  - Given a squash merge command against base `initiative/0000001-demo`
  - When `merge-guard` checks the command
  - Then it allows the merge, and it blocks the same command against `roadmap/0000001-demo`
- [ ] AC-3: CI runs on initiative branches
  - Given `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml`
  - When the CI template test reads the pull request branches
  - Then both list `initiative/**` and neither lists `roadmap/**`

## Dependencies
- REQ-007 guards these names against regression.
