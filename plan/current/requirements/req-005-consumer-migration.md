---
title: "Requirement: req-005 - consumer-migration"
summary: "One migration and two helper scripts move a consumer repo from the Planifest names to the RAVINTIO names, safely and repeatably."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - consumer-migration

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-005
**Priority:** must-have

## User Story

As a consumer, I run one migration that moves my overrides and workflow and removes old markers, so that my upgrade is safe.

## Functional Requirements
- Add the migration `ravintio-zero/migrations/0004-ravintio-rename.md` with status pending. The `ravintio-migrator` skill runs it.
- Add the helpers `ravintio-zero/migrations/migrate-ravintio-rename.sh` and `migrate-ravintio-rename.ps1`.
- Run the helper from the consumer repo root, after the consumer copies in `ravintio-zero/`.
- Run these steps in order:
  1. If `ravintio-zero/` is absent, print why and stop. Move nothing.
  2. If both `planifest-overrides/` and `ravintio-overrides/` exist, print a warning and stop. Move nothing.
  3. Move `planifest-overrides/` to `ravintio-overrides/`. Use `git mv` when git tracks the folder.
  4. Rename `.github/workflows/planifest.yml` to `ravintio.yml`. If `ravintio.yml` exists, stop.
  5. Remove `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`.
  6. Remove the old `planifest-zero/` folder.
  7. Print the next step: run `ravintio-zero/setup.sh claude-code`.
- After a run that changes the repo, move `0004-ravintio-rename.md` to `migrations/_done/`. A repo with no old install keeps it pending.
- The migration declares `Applies when:`. The orchestrator and `ravintio-migrator` skip a migration whose condition is false and leave it pending. This keeps 0004 from running in the pack source repo.
- Make each step skip work that is already done, so a rerun is safe.
- Refuse a source or target folder that is a symlink. Never follow a planted link.
- Make the `.sh` and `.ps1` helpers behave the same, including output and exit codes.
- Ship one test per helper. Each test covers the clean run, a rerun, each stop condition, and a symlink refusal.

## Acceptance Criteria
- [ ] In a scratch consumer repo, the helper moves the overrides and workflow, removes the markers and the old folder, and prints the setup command, in both `.sh` and `.ps1`.
- [ ] A rerun changes nothing and exits 0, and each stop condition (no `ravintio-zero/`, both override folders, existing `ravintio.yml`) exits non-zero and moves nothing.
- [ ] A symlinked `planifest-overrides/`, `ravintio-overrides/`, or `planifest-zero/` makes the helper refuse and leave the link and its target untouched.

## Dependencies
- REQ-001 (pack-identifiers) provides the `ravintio-zero/` folder and the `ravintio-migrator` skill.
- REQ-002 (runtime-names) makes setup detect the leftover folders and tell the consumer to run this migration first.
- Existing pattern: `migrate-archive-dirname.sh` and migration 0003.
