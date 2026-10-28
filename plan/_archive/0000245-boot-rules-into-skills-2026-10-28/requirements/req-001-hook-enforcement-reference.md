---
title: "Requirement: REQ-001 - Hook Enforcement reference"
summary: "Hook rules move to one reference file that the boot files and block messages name."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Hook Enforcement reference

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I read the hook rules from one reference file, so that the boot file stays small.

## Functional Requirements
- `ravintio-zero/standards/hook-enforcement.md` holds the Hook Enforcement list now in `standard-boot.md` and `codex-boot.md`.
- Both boot templates replace the section with a pointer to that file.
- The messages of `gate-write`, `ratchet-check`, `merge-guard`, `em-dash-guard`, and the `commit-msg` hook name the file.
- No hook changes what it allows or blocks.

## Acceptance Criteria
- [ ] AC-1: reference file holds the rules
  - Given the pack source
  - When a test reads `ravintio-zero/standards/hook-enforcement.md`
  - Then it names every hook that `standard-boot.md` listed before the move
- [ ] AC-2: boot files point to it
  - Given the two boot templates
  - When a test searches each for the file path
  - Then each holds the path and neither holds the old hook list
- [ ] AC-3: block messages name it
  - Given each blocking hook
  - When it blocks a fixture input
  - Then its message names `ravintio-zero/standards/hook-enforcement.md` and the exit code is unchanged

## Dependencies
- none
