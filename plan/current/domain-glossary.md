---
title: "Domain Glossary - story-mapping-and-gherkin"
summary: "Definitions of the story map and Gherkin terms used in this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - story-mapping-and-gherkin

**Skill:** plan
**Feature:** 0000170-story-mapping-and-gherkin
**Version:** 0.15.0

> The ubiquitous language for this feature. If the glossary says "Story map", the code says `story-map.md`, not "map file" or "plan map". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Story map | A table in `plan/current/story-map.md` that lays out a backbone of activities, steps, stories, and requirements. P1 writes it before it writes requirements. | None | ravintio-zero |
| Backbone | The ordered activities across the top of a story map. It shows the user's journey from left to right. | None | ravintio-zero |
| Activity | A high-level user goal in the backbone. Each activity holds one or more steps. | None | ravintio-zero |
| Step | A user action under an activity. Each step maps to a requirement or to a recorded gap. | None | ravintio-zero |
| Gap | A step that no requirement covers. A gap the brief states or implies becomes a story and a requirement. Any other gap goes to the out-of-scope list in `scope.md`. | None | ravintio-zero |
| Gherkin | A plain-text format for acceptance criteria. It uses `Given`, `When`, and `Then` lines. This feature writes Gherkin as Markdown lines, not as `.feature` files. | None | ravintio-zero |
| Scenario | A checkbox line in `## Acceptance Criteria` that states one testable criterion, written as `- [ ] AC-{n}: {name}`. Its Gherkin step lines sit beneath it. | Acceptance criterion, AC | ravintio-zero |
| Gherkin step | A `Given`, `When`, `Then`, `And`, or `But` line beneath a scenario. `And` and `But` continue the step above them. | Step line | ravintio-zero |
