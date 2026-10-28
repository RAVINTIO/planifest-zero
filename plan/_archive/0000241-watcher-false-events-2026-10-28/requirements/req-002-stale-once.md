---
title: "Requirement: REQ-002 - Each stale state prints once"
summary: "Each stale state prints once"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Each stale state prints once

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want each stale state reported once, so that the same warning does not repeat every pass.

## Functional Requirements
- The watcher keeps a stale key of the log modification time and the newest commit sha.
- It prints a stale line only when the key differs from the last key it printed.
- The key lives in memory only, so a new process starts with none.

## Acceptance Criteria
- [ ] AC-1: three passes, one line
  - Given a real stale state
  - When the watcher runs three passes with `--once --passes 3`
  - Then it prints exactly one stale line
- [ ] AC-2: restart
  - Given a printed stale state
  - When a new watcher process runs one pass
  - Then it prints the stale line again, because state stays in memory

## Dependencies
- REQ-001
