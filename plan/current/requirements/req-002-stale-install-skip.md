---
title: "Requirement: req-002 - stale install skip"
summary: "The installed-copies check skips in an active initiative when the install lags, and fails otherwise."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - stale install skip

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Source:** US-002
**Priority:** must-have

## User Story

As a step session, I see no failure from a stale installed copy, so that acceptance evidence stays free of repeated notes.

## Functional Requirements
- `helpers/assert.sh` defines `stale_install_skip_reason root`. It prints a reason and returns 0 only when `root/plan/current-initiative/initiative.md` has `status: "active"` and `root/.claude/skills/.ravintio-manifest` is older than the newest file under `root/ravintio-zero/skills/`.
- In every other case it prints nothing and returns 1.
- Section (c) of `test-0000151-req-014` prints `SKIP: {reason}` and runs no comparison when the helper returns 0. Otherwise it runs the comparison.

## Acceptance Criteria
- [ ] AC-1: skip in an active initiative with a stale manifest
  - Given an active initiative and a manifest older than the newest pack skill
  - When the helper runs
  - Then it prints a reason and returns 0
- [ ] AC-2: no skip outside an initiative
  - Given no initiative file, or a status other than active
  - When the helper runs with a stale manifest
  - Then it prints nothing and returns 1
- [ ] AC-3: no skip with a current manifest
  - Given an active initiative and a manifest newer than every pack skill
  - When the helper runs
  - Then it prints nothing and returns 1

## Dependencies
- None.
