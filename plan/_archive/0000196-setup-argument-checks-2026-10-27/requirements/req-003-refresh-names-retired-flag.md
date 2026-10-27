---
title: "Requirement: REQ-003 - refresh names a retired flag"
summary: "The refresh skill reports a retired flag in a setup record or marker instead of falling back without a word."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - refresh names a retired flag

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I refresh setup from a record that holds a retired flag and the refresh names that flag, so that I know why setup refused.

## Functional Requirements
- Step 3 of `ravintio-refresh-setup` checks the record at `plan/state/{tool}.md` and the marker `{tool-dir}/.ravintio-setup-flags` for a retired flag.
- When either holds one, the skill reports the flag name, says that it was removed, and says that setup rejects it.
- The skill never passes a retired flag to setup. It proposes the command without it and asks for confirmation as before.

## Acceptance Criteria
- [ ] AC-1: a record that holds a retired flag is reported
  - Given `plan/state/claude-code.md` lists `--context-mode-mcp`
  - When the skill reconstructs the flags
  - Then the report names `--context-mode-mcp` as removed and rejected by setup
- [ ] AC-2: a marker that holds a retired flag is reported
  - Given the marker lists `--include-full-skill-library` and the record is absent
  - When the skill reconstructs the flags
  - Then the report names that flag as removed and rejected by setup
- [ ] AC-3: the proposed command omits the retired flag
  - Given either source holds a retired flag
  - When the skill builds the command for confirmation
  - Then the command holds no retired flag

## Dependencies
- REQ-002, which makes setup reject the flag
