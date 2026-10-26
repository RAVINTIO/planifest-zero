---
title: "Requirement: req-008 - open backlog entries"
summary: "Open backlog entries use the new terms."
status: "draft"
version: "0.1.0"
---
# Requirement: req-008 - open backlog entries

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-007
**Priority:** must-have

## User Story

As the agent running the next initiative, I read open backlog entries in the new terms, so that no step needs to translate them.

## Functional Requirements
- Open entries 0000174 to 0000186 in `plan/backlog/` use the new names and prefixes wherever they mean the charted unit.
- Entry 0000182 names its skill `ravintio-initiative` and its marker `plan/.initiative-ack`.
- Entry 0000178 says "post-initiative retrospective".
- Entry 0000181 names `I-A` to `I-E`.
- Names of past runs stay as they are, because they name history.
- Each entry keeps its id, folder name, and status.

## Acceptance Criteria
- [ ] AC-1: Entries use new terms
  - Given `plan/backlog/` after this feature
  - When the guard test from REQ-007 searches it
  - Then it finds 0 old names outside the allowlist
- [ ] AC-2: Named entries carry the agreed wording
  - Given entries 0000178, 0000181, and 0000182
  - When a test reads them
  - Then they contain "post-initiative retrospective", `I-A`, and `ravintio-initiative` with `plan/.initiative-ack`

## Dependencies
- REQ-007 checks the result.
