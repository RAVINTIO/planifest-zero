# Requirement: REQ-002 - the boot file and skills

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0
**Source:** US-002
**Priority:** must-have

## User Story

As a developer who uses Codex, I get an `AGENTS.md` boot file and skills in `.agents/skills`, so that Codex loads the pipeline rules and skills.

## Functional Requirements
- `ravintio-zero/templates/codex-boot.md` holds the Codex boot text. It keeps the hard limits and operational directives of `standard-boot.md`.
- Setup for `codex` writes the template to `AGENTS.md` and appends the override instructions.
- Setup for `codex` installs every pack skill in `.agents/skills` and writes the manifest there.
- Setup for `codex` creates no `CLAUDE.md` and no `.claude` folder.

## Acceptance Criteria
- [ ] AC-1: AGENTS.md is written
  - Given a project with the pack installed
  - When you run `setup.sh codex`
  - Then `AGENTS.md` holds the hard limits and the override instructions
- [ ] AC-2: skills are installed
  - Given the same run
  - When a test lists `.agents/skills`
  - Then it holds `ravintio-orchestrator/SKILL.md` and a manifest
- [ ] AC-3: no Claude Code files appear
  - Given the same run
  - When a test lists the project root
  - Then `CLAUDE.md` and `.claude/` are absent

## Dependencies
- REQ-001
