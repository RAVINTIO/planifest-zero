---
title: "Requirement: req-005 - stray-feature-id"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - stray-feature-id

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-005
**Priority:** should-have

## User Story

As a maintainer, I start a pipeline run, so that P0 raises no false stale-marker flag from the root `.feature-id`.

## Functional Requirements
- Delete `.feature-id` from the repo root.

## Acceptance Criteria
- [ ] No `.feature-id` file exists at the repo root.
- [ ] No live file outside `plan/_archive/` and `plan/changelog/` refers to a root-level `.feature-id`.

## Dependencies
- None
