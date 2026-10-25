---
title: "Requirement: REQ-004 - story-map-consistency-rule"
summary: "consistency-check.mjs flags gaps between the story map and the requirement files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - story-map-consistency-rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Source:** US-004 (backlog 0000165)
**Priority:** must-have

## User Story

As a maintainer, I get a consistency check that flags a gap between the story map and the requirements, so that no mapped step goes unbuilt.

## Functional Requirements
- `ravintio-zero/scripts/consistency-check.mjs` reads `plan/current/story-map.md` when requirement files exist.
- The script flags a missing `story-map.md` when requirement files exist.
- The script flags a requirement whose Source `US-nnn` does not appear in the story map.
- The script flags a story map row whose Requirement cell is empty.
- The script flags a story map row whose Requirement cell names a `REQ-nnn` with no matching `req-nnn-*.md` file.
- A cell of the form `gap: {disposition}` counts as filled.
- If no requirement files exist, the script reports no story-map finding.
- Each finding names the file and, where one applies, the story or row.

## Acceptance Criteria
- [ ] AC-1: Missing map flagged
  - Given a fixture with requirement files and no `story-map.md`
  - When a test runs `node consistency-check.mjs` on the fixture directory
  - Then the exit code is 1 and stdout names `story-map.md` as missing
- [ ] AC-2: Row and story gaps flagged
  - Given a fixture map with an empty Requirement cell, a cell naming `REQ-009` with no file, and a requirement whose Source `US-nnn` is absent from the map
  - When a test runs `node consistency-check.mjs` on the fixture directory
  - Then stdout holds one finding for each of the three defects and the exit code is 1
- [ ] AC-3: Clean and empty cases pass
  - Given a clean fixture whose map holds `REQ-nnn` cells and a `gap: out of scope` cell, and a second fixture with no requirement files
  - When a test runs `node consistency-check.mjs` on each directory
  - Then neither run reports a story-map finding

## Dependencies
- REQ-001 defines the story map template and the gap cell forms this rule reads.
- REQ-003 adds the Gherkin rule to the same script.
