---
title: "Requirement: REQ-001 - story-map-pass"
summary: "The plan skill runs a story mapping pass from a new template before it writes requirements."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - story-map-pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Source:** US-001 (backlog 0000165)
**Priority:** must-have

## User Story

As a maintainer, I get a story map from P1 that lays out activities and steps, so that a story the brief missed shows up as a gap.

## Functional Requirements
- Today P1 turns each user story into one requirement. Nothing checks the stories for gaps.
- Add `ravintio-zero/templates/story-map.template.md`. It holds a `## Backbone` table with the columns `| Activity | Step | Story | Requirement |`.
- A Requirement cell holds `REQ-nnn` or `gap: {disposition}`. The disposition is `out of scope` or `added as US-nnn`.
- `ravintio-zero/skills/ravintio-plan/SKILL.md` gains a story mapping pass. It runs before the plan skill writes any requirement file (ADR-002).
- The pass writes `plan/current/story-map.md` from the template.
- The plan skill lists `plan/current/story-map.md` in its minimal default artifact set.
- The plan skill adds `story-map.template.md` to `bundle_templates`.
- Gap rule: a gap the brief states or implies becomes a new story and a new requirement. Any other gap goes to the scope's out-of-scope list.
- In a gated run, P1 asks the human about a gap of the second kind. It asks one question at a time.

## Acceptance Criteria
- [ ] AC-1: Template exists
  - Given the repository at this feature's release
  - When a test reads `ravintio-zero/templates/story-map.template.md`
  - Then the file holds a `## Backbone` heading and the header row `| Activity | Step | Story | Requirement |`
- [ ] AC-2: Skill lists the map
  - Given `ravintio-zero/skills/ravintio-plan/SKILL.md`
  - When a test searches the `bundle_templates` line and the artifact table
  - Then `story-map.template.md` appears in the first and `plan/current/story-map.md` appears in the second
- [ ] AC-3: Skill states the gap rule
  - Given `ravintio-zero/skills/ravintio-plan/SKILL.md`
  - When a test searches the story mapping pass text
  - Then the text puts the pass before requirement writing, names `out of scope` and `added as US-nnn`, and says P1 asks one question at a time in a gated run

## Dependencies
- REQ-004 checks the story map this requirement produces.
- REQ-002 shares the plan skill file and edits its requirements rules.
