---
title: "Requirement: REQ-002 - gate-write-documented-scope"
summary: "The gate-write hook and the docs state which paths the hook gates, including plan/backlog/ and plan/roadmap/."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - gate-write-documented-scope

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Source:** US-002 (backlog 0000162)
**Priority:** must-have

## User Story

As a maintainer, I read in `CLAUDE.md` and the hook which paths it gates, including `plan/backlog/` and `plan/roadmap/` between runs, so that docs match behaviour.

## Functional Requirements
- The allowed set stays as it is: the `plan/` and `docs/` prefixes plus the always-permitted basenames.
- `gate-write.mjs` names `plan/backlog/` and `plan/roadmap/` in its header comment as allowed between runs, with no sentinel and no design needed.
- A test writes to `plan/backlog/` and `plan/roadmap/` with no sentinel and no `design.md`, and expects exit 0.
- The `gate-write` bullet in `CLAUDE.md` says the hook gates every in-project path that is not always permitted. It also states the `plan/current/` sentinel check and that targets outside the project pass.
- The same correction applies to each other file that describes `gate-write` as blocking only `src/`:
  - `ravintio-zero/templates/standard-boot.md`, which setup copies into consumer `CLAUDE.md` files.
  - `ravintio-zero/pipeline-reference.md`, in the hooks table and the section "How gate-write interacts with design.md".
  - `ravintio-zero/project-operations.md`, in the hooks table.

## Acceptance Criteria
- [ ] A test shows writes to `plan/backlog/` and `plan/roadmap/` exit 0 without a sentinel or `design.md`.
- [ ] The allowed prefixes and basenames in `gate-write.mjs` are unchanged.
- [ ] The `gate-write` bullet in `CLAUDE.md` no longer says it "Blocks writes to `src/`". It states the gated paths, the sentinel check, and that outside targets pass.
- [ ] `standard-boot.md`, `pipeline-reference.md`, and `project-operations.md` carry the same description.

## Dependencies
- REQ-001 sets the outside-project behaviour that these docs describe.
