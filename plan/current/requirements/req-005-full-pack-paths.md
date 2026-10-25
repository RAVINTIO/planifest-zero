---
title: "Requirement: REQ-005 - full-pack-paths"
summary: "Every skill names a pack template, standard, or schema by its full ravintio-zero path."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - full-pack-paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Source:** Requirement change 2026-10-25 (human request during R-D Advance)
**Priority:** must-have

## User Story

As an agent running a skill, I open a template or standard by an exact path, so that I never search for it or open the wrong copy.

## Functional Requirements
- Every mention of a pack template, standard, or schema in `ravintio-zero/skills/**/*.md` uses its full path, such as `ravintio-zero/templates/requirement.template.md`.
- Short paths such as `templates/story-map.template.md` and bare names such as `roadmap-standards.md` become full paths.
- The `bundle_templates` and `bundle_standards` frontmatter fields leave every SKILL.md.
- A skill's own files, such as `references/orchestrator-scope-lock.md`, keep their skill-relative paths.

## Acceptance Criteria
- [ ] AC-1: No short paths remain
  - Given the skill sources after the change
  - When the REQ-006 check runs
  - Then it reports no short path and no bare name
- [ ] AC-2: No bundle fields remain
  - Given the skill sources after the change
  - When a test searches each SKILL.md frontmatter
  - Then no `bundle_templates` or `bundle_standards` line exists

## Dependencies
- REQ-006
