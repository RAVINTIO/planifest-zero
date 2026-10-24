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
- Run the helper from the consumer project root, the folder that holds `ravintio-zero/`, after the consumer copies it in. The project root may sit below the git top level.
- Run these steps in order:
  1. If `ravintio-zero/` is absent, print why and stop. Move nothing.
     Before this step, stop and move nothing if `planifest-zero`, `planifest-overrides`, `ravintio-overrides`, `.ravintio-backup`, or either workflow file is a symlink, dangling or not. Print why.
  2. If both `planifest-overrides/` and `ravintio-overrides/` exist, print a warning and stop. Move nothing.
  3. Move `planifest-overrides/` to `ravintio-overrides/`. Use `git mv` when git tracks the folder.
  4. Rename `.github/workflows/planifest.yml` to `ravintio.yml`. If `ravintio.yml` exists, stop. Rewrite `planifest-zero/` to `ravintio-zero/` inside it. Rewrite only the pack's own variables, `PLANIFEST_` followed by `REQUIRE_PWSH`, `PWSH`, `TEST_QUIET`, `PREFLIGHT_ONLY`, `REGRESSION_DIR`, `ROADMAP_MODEL`, or `ROADMAP_MAX_TURNS`, to `RAVINTIO_`. Leave every other `PLANIFEST_` name, such as a consumer secret. Write to a temp file in the same folder and rename it over the target.
  5. Remove `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`.
  6. Move the old `planifest-zero/` folder to `.ravintio-backup/planifest-zero/`. Never delete it. If git tracks a file under it, run `git rm -r -q --cached -- planifest-zero` first. Move it with a plain rename, which never follows a nested link. Inside a git work tree, add `.ravintio-backup/` to `.git/info/exclude` once. Print that the human deletes `.ravintio-backup/` after checking it. If `.ravintio-backup/planifest-zero` exists, stop before any move.
  7. Print the next step: run `ravintio-zero/setup.sh claude-code`.
- If a parent folder is a symlink, skip only the step that writes through it, print a warning, and carry on. A link at `.github` or `.github/workflows` skips step 4. A link at `.claude` or `.claude/skills` skips the marker under it. A link at `ravintio-zero` or `ravintio-zero/migrations` skips the archive step.
- After a run that changes the repo, move `0004-ravintio-rename.md` to `migrations/_done/`. A repo with no old install keeps it pending.
- The migration declares `Applies when:`. The orchestrator and `ravintio-migrator` skip a migration whose condition is false and leave it pending. This keeps 0004 from running in the pack source repo.
- Make each step skip work that is already done, so a rerun is safe.
- Refuse a source or target that is a symlink. Never follow a planted link. A dangling link counts as a link.
- Make the `.sh` and `.ps1` helpers behave the same, including output and exit codes.
- Ship one test per helper. Each test covers these cases:
  - the clean run and a rerun
  - each stop condition and each symlink refusal
  - each parent-link skip
  - the backup move of a tracked and an untracked pack, with a nested link and a stray untracked file
  - a project below its git top level
  - a consumer secret that keeps its `PLANIFEST_` name

## Acceptance Criteria
- [ ] In a scratch consumer repo, the helper moves the overrides and workflow, removes the markers, moves the old pack folder to `.ravintio-backup/`, and prints the setup command, in both `.sh` and `.ps1`.
- [ ] A rerun changes nothing and exits 0, and each stop condition (no `ravintio-zero/`, both override folders, existing `ravintio.yml`, existing backup) exits non-zero and moves nothing.
- [ ] A symlinked `planifest-overrides/`, `ravintio-overrides/`, or `planifest-zero/` makes the helper refuse and leave the link and its target untouched.

## Dependencies
- REQ-001 (pack-identifiers) provides the `ravintio-zero/` folder and the `ravintio-migrator` skill.
- REQ-002 (runtime-names) makes setup detect the leftover folders and tell the consumer to run this migration first.
- Existing pattern: `migrate-archive-dirname.sh` and migration 0003.
