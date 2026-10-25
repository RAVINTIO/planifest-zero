---
title: "Requirement: REQ-001 - strict-mode-section"
summary: "The strict mode section in project-operations.md explains both files, the handshake, the ack file's name, and the roadmap case."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - strict-mode-section

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000185-explain-strict-mode
**Source:** US-001 (backlog 0000184)
**Priority:** must-have

## User Story

As a pack user, I read one section in `project-operations.md` and learn what strict mode does and what `plan/.orchestrator-ack` holds, so that the banner and the file make sense.

## Functional Requirements
- The `## Strict Orchestrator Mode` section keeps its heading, so its anchor stays `#strict-orchestrator-mode`.
- The section names the `--strict-orchestrator` flag for `setup.sh` and `setup.ps1`, and `plan/.orchestrator-strict`.
- The section explains the handshake as numbered steps. It says the hook acts only while `plan/.orchestrator-active` exists.
- The section says what `plan/.orchestrator-ack` holds, including the timestamp fallback, and why the file has that name.
- The section says ship deletes the file, and what happens in a roadmap run. It names backlog entry 0000182.

## Acceptance Criteria
- [ ] AC-1: Section names both files and the flag
  - Given `ravintio-zero/project-operations.md`
  - When a test reads the `## Strict Orchestrator Mode` section
  - Then it finds `plan/.orchestrator-strict`, `plan/.orchestrator-ack`, and `--strict-orchestrator`
- [ ] AC-2: Section explains the file's content and name
  - Given the same section
  - When a test reads it
  - Then it finds the word `acknowledg` and the session id
  - And it finds the timestamp fallback
- [ ] AC-3: Section covers the roadmap case
  - Given the same section
  - When a test reads it
  - Then it finds `roadmap` and `0000182`

## Dependencies
- None.
