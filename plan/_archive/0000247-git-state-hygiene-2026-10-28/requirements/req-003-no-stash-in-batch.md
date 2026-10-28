---
title: "Requirement: REQ-003 - No stash in a parallel batch"
summary: "The dispatch standard and each skeleton prompt forbid git stash in a subagent during a parallel batch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - No stash in a parallel batch

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see subagents in a parallel batch leave git state alone, so that no subagent loses its siblings' uncommitted work.

## Functional Requirements
- `agent-dispatch-standards.md` forbids `git stash` in a subagent during a parallel batch, and states that a stash takes the uncommitted work of every other subagent.
- Each prompt in the parallel dispatch skeleton forbids `git stash`.
- `### Resuming an interrupted unit` still tells the parent to stash.

## Acceptance Criteria
- [ ] AC-1: the rule and its reason
  - Given the dispatch standard
  - When the test reads it
  - Then it forbids `git stash` in a subagent during a batch and gives the reason
- [ ] AC-2: skeleton prompts
  - Given the skeleton prompts
  - When the test reads them
  - Then each forbids `git stash`
- [ ] AC-3: parent resume stash kept
  - Given the resume section
  - When the test reads it
  - Then it still holds `git stash push`

## Dependencies
- none
