---
title: "Requirement: req-005 - consumer migration"
summary: "Migration 0005 moves a consumer's drafts and CI pattern to the new names."
status: "draft"
version: "0.1.0"
---
# Requirement: req-005 - consumer migration

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-005
**Priority:** must-have

## User Story

As a consumer, I run migration 0005 to move my drafts and CI pattern to the new names, so that an upgrade keeps my open drafts.

## Functional Requirements
- `ravintio-zero/migrations/0005-initiative-rename.md` follows the format of migration 0004, with Bash and PowerShell helpers.
- The helper renames each `plan/roadmap/{id}-{slug}/roadmap.md` to `initiative.md` in place.
- The helper changes `roadmap/**` to `initiative/**` in `.github/workflows/ravintio.yml`.
- The helper renames `plan/.roadmap-logs/` to `plan/.initiative-logs/` when it exists.
- The helper stops before any change while `plan/current-roadmap/` exists, and names that folder.
- A rerun changes nothing and exits zero.
- `Applies when:` names a `plan/roadmap/*/roadmap.md` file or a `roadmap/**` CI pattern. The pack source has neither after this feature, so the migration stays pending there.

## Acceptance Criteria
- [ ] AC-1: Migration renames drafts and the CI pattern
  - Given a fixture repo with `plan/roadmap/0000001-demo/roadmap.md` and `roadmap/**` in its CI workflow
  - When the test runs the Bash helper, then the PowerShell helper on a fresh copy
  - Then each leaves `initiative.md` in the draft folder and `initiative/**` in the workflow
- [ ] AC-2: Migration stops while a roadmap is active
  - Given the same fixture plus `plan/current-roadmap/roadmap.md`
  - When the test runs each helper
  - Then each exits non-zero, names `plan/current-roadmap/`, and changes no file
- [ ] AC-3: Rerun changes nothing
  - Given a fixture the helper has already migrated
  - When the test runs the helper again
  - Then it exits zero and the tree is unchanged

## Dependencies
- REQ-002 sets the target names.
