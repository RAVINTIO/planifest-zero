---
title: "Requirement: REQ-002 - Targeted overrides"
summary: "An override names one pack skill and setup appends it there."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Targeted overrides

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Source:** US-002
**Priority:** must-have

## User Story

As a repo owner, I name a pack skill in an override, so that setup appends the rule to that skill and not to the boot file.

## Functional Requirements
- An override whose frontmatter holds `target: {skill}` is appended to the installed `{skill}/SKILL.md` between marker comments.
- Setup strips the frontmatter from the appended text and leaves the override out of the boot file.
- The value must match `^[a-z0-9][a-z0-9-]*$` and name an installed skill folder. Otherwise setup warns and appends the override to the boot file.
- Each run removes the earlier marker block first, so a rerun never doubles it.
- An override with no `target:` goes to the boot file as before.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria
- [ ] AC-1: targeted override lands in the skill
  - Given an override with `target: ravintio-ship`
  - When setup runs twice
  - Then the installed ship skill holds the text once and the boot file does not hold it
- [ ] AC-2: bad target falls back
  - Given an override whose target is missing or malformed
  - When setup runs
  - Then setup warns and the boot file holds the text
- [ ] AC-3: untargeted override unchanged
  - Given an override with no target
  - When setup runs
  - Then the boot file holds it

## Dependencies
- none
