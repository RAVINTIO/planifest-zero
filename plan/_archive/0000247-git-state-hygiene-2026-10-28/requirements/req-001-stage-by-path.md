---
title: "Requirement: REQ-001 - Stage by path in an initiative"
summary: "The orchestrator and ship skills tell a step to stage artifacts by explicit path and leave queued backlog entries untracked."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Stage by path in an initiative

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see a step leave queued backlog entries untracked, so that each entry lands in its own commit.

## Functional Requirements
- `ravintio-orchestrator/SKILL.md` tells a step of an active initiative to stage artifacts by explicit path and never to stage a `plan/backlog/` entry the step did not write.
- `ravintio-ship/SKILL.md` Step 4 stages by explicit path in an active initiative: `plan/current/`, `plan/changelog/`, `plan/_archive/`, and the link updates. It names the same ban.
- The orchestrator skill stays at 9,000 bytes or fewer.

## Acceptance Criteria
- [ ] AC-1: orchestrator carries the rule
  - Given the orchestrator skill
  - When the test reads it
  - Then it finds the explicit-path rule and the ban on staging other backlog entries
- [ ] AC-2: ship skill carries the rule
  - Given the ship skill
  - When the test reads it
  - Then it finds the explicit paths and the same ban
- [ ] AC-3: orchestrator stays under its cap
  - Given the orchestrator skill
  - When the test measures it
  - Then it holds 9,000 bytes or fewer

## Dependencies
- none
