---
title: "Requirement: req-003 - old-name guard"
summary: "The old-name guard flags the old lock name and the old archive folder pattern."
status: "draft"
version: "0.1.0"
---
# Requirement: req-003 - old-name guard

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000192-rename-runner-lock-and-archive
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I get a failing test when either old name comes back, so that the rename stays complete.

## Functional Requirements
- `test-0000189-req-007-old-name-guard.sh` flags the old lock file name and the old archive folder pattern, as written in the standards before this feature.
- The driver keeps the `-roadmap-` prefix for the old archive form, and stays on the allowlist.
- Real archive folder names, such as `0000168-backlog-clearance-roadmap-2026-10-25`, do not match the pattern.

## Acceptance Criteria
- [ ] AC-1: Repo is clean
  - Given the tracked files after this feature
  - When the guard runs
  - Then it finds 0 old names outside its allowlist
- [ ] AC-2: Planted old names fail
  - Given a scratch file holding the old `roadmap-runner` lock or the old `-roadmap-` form
  - When the guard checks it
  - Then it fails and names the file and line

## Dependencies
- REQ-001 and REQ-002 remove the old names first.
