---
title: "Requirement: REQ-001 - A stale line needs a commit 15 minutes newer than the log"
summary: "A stale line needs a commit 15 minutes newer than the log"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - A stale line needs a commit 15 minutes newer than the log

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative owner, I want a stale line only when a commit is at least 15 minutes newer than the log, so that a fresh commit is not flagged.

## Functional Requirements
- The watcher prints `I-C Run: stale:` only when the newest commit time minus the build log modification time is at least `STALE_MS` (900000).

## Acceptance Criteria
- [ ] AC-1: fresh commit
  - Given a commit 5 seconds newer than the build log and a clock 20 minutes after the log
  - When the watcher runs one pass
  - Then it prints no stale line
- [ ] AC-2: real stale state
  - Given a commit 20 minutes newer than the build log
  - When the watcher runs one pass
  - Then it prints one stale line

## Dependencies
- None
