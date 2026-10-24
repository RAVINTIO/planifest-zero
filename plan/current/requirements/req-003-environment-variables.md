---
title: "Requirement: REQ-003 - environment-variables"
summary: "Rename PLANIFEST_* environment variables to RAVINTIO_* with a 1.x fallback for the roadmap variables."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - environment-variables

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-003
**Priority:** must-have

## User Story

As a roadmap user, I set `RAVINTIO_*` variables, and my old `PLANIFEST_ROADMAP_*` values still work in 1.x, so that my upgrade doesn't break my runs.

## Functional Requirements
- Rename all 26 `PLANIFEST_*` variables to `RAVINTIO_*` in code, tests, docs, and workflows.
- `roadmap-run.mjs` reads `RAVINTIO_ROADMAP_MODEL` and `RAVINTIO_ROADMAP_MAX_TURNS` first.
- If a new name is unset, `roadmap-run.mjs` falls back to `PLANIFEST_ROADMAP_MODEL` or `PLANIFEST_ROADMAP_MAX_TURNS` in 1.x.
- If both names are set, the `RAVINTIO_*` value wins.
- Rename the OTEL labels `planifest.roadmap` and `planifest.step` to `ravintio.roadmap` and `ravintio.step`.
- No other `PLANIFEST_*` variable has a fallback.

## Acceptance Criteria
- [ ] No `PLANIFEST_*` variable remains in the repository outside the two roadmap fallbacks, history folders, and the migration.
- [ ] `roadmap-run.mjs` returns the `RAVINTIO_*` value when only it is set, the `PLANIFEST_*` value when only that is set, and the `RAVINTIO_*` value when both are set.
- [ ] `roadmap-run.mjs` emits the OTEL labels `ravintio.roadmap` and `ravintio.step`, and never `planifest.*`.

## Dependencies
- REQ-001 provides the renamed paths.
