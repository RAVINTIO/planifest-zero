---
title: "Requirement: req-001 - glossary"
summary: "One glossary defines roadmap, roadmap initiative, and the initiative states."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - glossary

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I read one glossary that defines "roadmap" and "roadmap initiative" and the initiative states, so that I use each word for one thing.

## Functional Requirements
- `ravintio-zero/project-operations.md` holds one glossary section with three entries: "Roadmap", "Roadmap initiative", and "Initiative states".
- "Roadmap" means the long-term plan for the product. `plan/roadmap/` holds it, with one subfolder per initiative.
- "Roadmap initiative" means a goal that delivers a string of feature builds. Each build merges into the initiative branch, and that branch merges to `main` in one PR. After first mention, prose says "initiative".
- "Initiative states" lists proposed, charted, active, delivered, and blocked, with the stage that sets each one.
- `ravintio-zero/standards/roadmap-standards.md` links to the glossary rather than defining the terms again.

## Acceptance Criteria
- [ ] AC-1: Glossary defines both terms
  - Given the pack source after this feature
  - When a maintainer opens `ravintio-zero/project-operations.md`
  - Then one section defines "Roadmap" and "Roadmap initiative" in the words above
- [ ] AC-2: Glossary lists the five states
  - Given the glossary section
  - When a maintainer reads "Initiative states"
  - Then it names proposed, charted, active, delivered, and blocked, and the stage that sets each
- [ ] AC-3: Standard links to the glossary
  - Given `roadmap-standards.md`
  - When a test searches it for a link to the glossary section
  - Then the link exists and resolves

## Dependencies
- REQ-004 sets the same five states in the template.
