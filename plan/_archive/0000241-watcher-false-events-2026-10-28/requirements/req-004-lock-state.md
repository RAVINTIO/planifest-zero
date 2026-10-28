---
title: "Requirement: REQ-004 - The heartbeat reports the real lock state"
summary: "The heartbeat reports the real lock state"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - The heartbeat reports the real lock state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Source:** US-004
**Priority:** must-have

## User Story

As an initiative owner, I want the heartbeat to show the real lock state, so that it matches the driver.

## Functional Requirements
- The watcher reads the lock file on each heartbeat and reports `lock held` or `lock free` from it.

## Acceptance Criteria
- [ ] AC-1: lock removed
  - Given a lock file that existed on an earlier pass and is now removed, with the initiative file still present
  - When the watcher prints a heartbeat
  - Then the heartbeat says `lock free`
- [ ] AC-2: lock present
  - Given the lock file exists
  - When the watcher prints a heartbeat
  - Then the heartbeat says `lock held`

## Dependencies
- None
