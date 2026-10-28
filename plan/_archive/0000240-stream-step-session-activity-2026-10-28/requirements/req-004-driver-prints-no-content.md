---
title: "Requirement: REQ-004 - Driver prints no step content"
summary: "Driver prints no step content"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Driver prints no step content

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative owner, I want the driver to keep step content out of its own output, so that private file content stays in the log.

## Functional Requirements
- The driver writes stdout to the log only.
- The driver copies stderr to its own stderr, as now.

## Acceptance Criteria
- [ ] AC-1: stdout stays private
  - Given a stub `claude` that prints a marker string in stream events
  - When the driver runs a step
  - Then the driver's stdout and stderr hold no marker string

## Dependencies
- REQ-001
