---
title: "Requirement: req-006 - human-request-source"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-006 - human-request-source

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-006
**Priority:** should-have

## User Story

As a human filing a backlog idea, I set the deferral source to `human request`, so that the entry matches the template.

## Functional Requirements
- Add `human request` as a fourth deferral source in `planifest-zero/templates/backlog-entry.template.md`, with one sentence on when to use it.
- Allow `none (human request)` for the source feature and source phase fields.

## Acceptance Criteria
- [ ] The template's deferral source field lists `human request`.
- [ ] The template's guidance states when to use `human request` and allows `none (human request)` for source feature and source phase.

## Dependencies
- None
