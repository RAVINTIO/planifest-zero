# Requirement: REQ-001 - the codex tool target

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0
**Source:** US-001
**Priority:** must-have

## User Story

As a developer who uses Codex, I run `setup.sh codex` or `setup.ps1 codex`, so that the pack installs for my harness.

## Functional Requirements
- `VALID_TOOLS` in `setup.sh` and `$ValidTools` in `setup.ps1` list `codex` beside `claude-code`.
- `ravintio-zero/setup/codex.sh` and `ravintio-zero/setup/codex.ps1` hold the Codex config.
- The setup usage text lists `codex`.
- The refresh-setup skill names `codex` as a supported tool.

## Acceptance Criteria
- [ ] AC-1: setup accepts codex
  - Given a project with the pack installed
  - When you run `setup.sh codex`
  - Then setup exits 0 and writes `plan/state/codex.md`
- [ ] AC-2: an unknown tool still fails
  - Given the same project
  - When you run `setup.sh cursor`
  - Then setup exits 1, prints `Valid tools: claude-code codex`, and changes nothing
- [ ] AC-3: the refresh skill lists codex
  - Given the refresh-setup skill
  - When a test reads it
  - Then it names `codex` as a supported tool

## Dependencies
- none
