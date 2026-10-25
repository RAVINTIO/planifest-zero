---
title: "Requirement: REQ-002 - strict-mode-links"
summary: "The getting-started and README strict mode rows link to the strict mode section."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - strict-mode-links

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000185-explain-strict-mode
**Source:** US-002 (backlog 0000184)
**Priority:** must-have

## User Story

As a pack user, I follow the strict mode link from `getting-started.md` or `README.md` and land on that section, so that I find it without searching.

## Functional Requirements
- The `getting-started.md` row "Orchestrator sentinel and strict mode" links to `project-operations.md#strict-orchestrator-mode`.
- The `README.md` `--strict-orchestrator` row links to `ravintio-zero/project-operations.md#strict-orchestrator-mode`.

## Acceptance Criteria
- [ ] AC-1: Getting-started row links to the section
  - Given `ravintio-zero/getting-started.md`
  - When a test reads the strict mode row
  - Then it links to `project-operations.md#strict-orchestrator-mode`
- [ ] AC-2: README row links to the section
  - Given `README.md`
  - When a test reads the `--strict-orchestrator` row
  - Then it links to `ravintio-zero/project-operations.md#strict-orchestrator-mode`
- [ ] AC-3: The anchor resolves
  - Given `ravintio-zero/project-operations.md`
  - When a test lists its headings
  - Then it finds `## Strict Orchestrator Mode`

## Dependencies
- REQ-001 keeps the heading.
