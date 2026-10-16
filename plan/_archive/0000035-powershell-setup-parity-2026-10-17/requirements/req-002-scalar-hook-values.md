---
title: "Requirement: req-002 - scalar-hook-values"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - scalar-hook-values

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Source:** US-002, backlog 0000094
**Priority:** should-have

## User Story

As a user with a hand-edited `settings.json`, I run `setup.ps1`, so that the legacy cleanup leaves a non-array hook value as it was.

## Functional Requirements
- `Remove-LegacyTelemetryWiring` skips any hook event whose value isn't an array, and leaves it unchanged.
- Array values keep today's behaviour.

## Acceptance Criteria
- [ ] The cleanup loop tests each event value with `-isnot [System.Array]` and continues before it wraps the value.
- [ ] The loop never assigns back to an event it skipped.

## Dependencies
- None
