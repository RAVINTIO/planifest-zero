---
title: "Requirement: REQ-004 - no-skill-bundling"
summary: "setup.sh and setup.ps1 install only each skill's own files, with no bundled pack copies."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - no-skill-bundling

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** Requirement change 2026-10-25 (human request during R-D Advance)
**Priority:** must-have

## User Story

As a consumer, I run setup and get one copy of each pack file, so that installs are fast and no stale copy can drift from the pack.

## Functional Requirements
- `setup.sh` and `setup.ps1` copy each skill's own folder, `ravintio-zero/skills/{skill}/`, to `.claude/skills/{skill}/`.
- Neither script copies pack templates, standards, or schemas into a skill. No skill gets an `assets/` or a pack `references/` folder.
- A skill's own `references/` folder, such as the orchestrator's, still installs.
- Neither script parses `bundle_templates` or `bundle_standards`, and neither prints a `templates:` or `standards:` bundle line.
- Neither script rewrites relative paths in SKILL.md. Each installed SKILL.md matches its source.
- A rerun removes a bundled `assets/` folder or bundled pack file left by an older install. It never removes a file from the skill's own source folder.
- Both scripts produce the same installed tree.

## Acceptance Criteria
- [ ] AC-1: Only own files install
  - Given a fresh workspace
  - When a test runs `setup.sh claude-code` and, separately, `setup.ps1 claude-code`
  - Then each `.claude/skills/{skill}/` holds exactly the files of `ravintio-zero/skills/{skill}/`, byte for byte
- [ ] AC-2: Old bundles go on rerun
  - Given a workspace with an older install that holds `assets/templates/` and bundled `references/*-standards.md` files
  - When a test runs setup again
  - Then those bundled files are gone and the skill's own files remain

## Dependencies
- ADR-004
