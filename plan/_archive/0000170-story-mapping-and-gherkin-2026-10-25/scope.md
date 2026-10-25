---
title: "Scope - story-mapping-and-gherkin"
summary: "Boundaries for the P1 story map, the Gherkin acceptance criteria, and their consistency and ratchet checks."
status: "draft"
version: "0.1.0"
---
# Scope - story-mapping-and-gherkin

**Skill:** plan
**Feature:** 0000170-story-mapping-and-gherkin
**Version:** 0.15.0

## In Scope

- `ravintio-zero/templates/story-map.template.md` holds a backbone table of activities, steps, stories, and requirements.
- The plan skill runs the mapping pass before it writes requirements. It lists the story map in its default artifact set.
- `requirement.template.md` writes each criterion as `- [ ] AC-{n}: {name}` with indented `Given`, `When`, and `Then` lines. `And` and `But` continue the step above.
- `consistency-check.mjs` flags a criterion that lacks `Given`, `When`, or `Then`, or holds them out of order.
- `consistency-check.mjs` flags a missing story map when requirements exist. It also flags a requirement whose story is not in the map, and a map row with no requirement or gap.
- `ratchet-check.mjs` guards Gherkin step lines in `## Acceptance Criteria`.
- The 0000016 consistency-check and ratchet fixtures move to the Gherkin format, in the feature and regression copies.
- Version 0.15.0.

## Out of Scope

- Rewriting criteria in archived runs.
- A Gherkin test runner such as Cucumber.
- Other backlog entries.

## Deferred

Nothing deferred.
