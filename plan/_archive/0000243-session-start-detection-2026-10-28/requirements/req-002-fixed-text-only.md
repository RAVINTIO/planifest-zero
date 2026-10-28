---
title: "Requirement: REQ-002 - The script prints fixed text only"
summary: "The script prints fixed text only"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The script prints fixed text only

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want the script to print no repo text, so that a hostile commit cannot plant instructions in the hook output.

## Functional Requirements
- The script prints fixed messages, ids that match a strict pattern, and repo-relative paths.
- An id or path that fails its pattern prints as `unreadable`.

## Acceptance Criteria
- [ ] AC-1: planted text
  - Given a `pause.md` and a build log that hold instruction text
  - When the script runs
  - Then no part of that text appears in the output
- [ ] AC-2: bad id
  - Given a migration file or `In progress:` line whose id fails the pattern
  - When the script runs
  - Then the line reads `unreadable`

## Dependencies
- REQ-001
