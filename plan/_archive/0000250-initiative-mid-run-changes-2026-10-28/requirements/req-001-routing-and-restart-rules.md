---
title: "Requirement: REQ-001 - routing and restart rules"
summary: "The initiative skill routes a mid-run repo instruction into step scope and restarts the driver on the restart stop."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - routing and restart rules

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000250-initiative-mid-run-changes
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As a maintainer, I see the initiative skill add a mid-run repo instruction to the scope of the current or next pending step in `initiative.md`, and restart the driver and the watcher on the restart stop, so that a step writes the override and later steps run the new code.

## Functional Requirements
- `ravintio-initiative/SKILL.md` has a rule for a repo instruction that the human asks for while a step runs.
- The rule names `plan/current-initiative/initiative.md` as the target and the current or next pending step as the scope.
- While the driver lock is held, the skill queues the instruction and adds it to `initiative.md` when the driver is between steps or stopped. It commits the edit on the initiative branch.
- The rule says the skill never writes the override file from the initiative session.
- The skill's Stops section says that a `Restart:` line means a restart, not a failure. The skill starts a new driver and a new watcher at once and asks nothing.
- `ravintio-zero/standards/roadmap-standards.md` holds the same two rules.
- The `gate-write` hook and its tests stay unchanged.

## Acceptance Criteria
- [ ] AC-1: the skill holds the routing rule
  - Given the initiative skill
  - When the test reads it
  - Then it finds `initiative.md` as the target, the current or next pending step as the scope, and a statement that the skill never writes the override
- [ ] AC-2: the skill holds the restart rule
  - Given the initiative skill
  - When the test reads its Stops section
  - Then it finds the `Restart:` line and the instruction to start a new driver and watcher without asking
- [ ] AC-3: the hook stays unchanged
  - Given the diff of this feature against the initiative branch
  - When P3 lists the changed paths
  - Then no path under `ravintio-zero/hooks/` and no `gate-write` test appears

## Dependencies
- none
