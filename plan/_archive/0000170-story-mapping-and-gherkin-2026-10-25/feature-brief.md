---
title: "Feature Brief - story mapping and Gherkin"
summary: "One backlog entry: a story mapping pass in P1, and acceptance criteria written in Gherkin."
status: "approved"
version: "0.15.0"
---
# Feature Brief - story mapping and Gherkin

**Feature ID:** 0000170-story-mapping-and-gherkin

## Business Goal

The plan phase turns each user story into one requirement, but nothing checks the stories for gaps. A story the brief missed never becomes a requirement. Acceptance criteria are free text, so tests can't map to them line by line. This release adds a story map to P1 and writes every criterion in Gherkin.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Story map in P1 (0000165) | As a maintainer, I get a story map from P1 that lays out activities and steps, so that a story the brief missed shows up as a gap. | must-have | 1 |
| Gherkin acceptance criteria (0000165) | As a test writer, I read each acceptance criterion as `Given`, `When`, and `Then` lines, so that each test maps to one criterion line by line. | must-have | 1 |

## Acceptance criteria

1. The plan skill runs a story mapping pass before it writes requirements. It writes `plan/current/story-map.md` from a new template, and each step maps to a requirement or a recorded gap.
2. The requirement template writes each criterion as a checkbox line with `Given`, `When`, and `Then` lines under it. The three-criteria limit counts checkbox lines, not steps.
3. The consistency check flags a criterion without `Given`, `When`, and `Then` in that order. It also flags a requirement missing from the story map and a step with no requirement or gap.
4. The ratchet hook guards the Gherkin step lines as well as the checkbox lines.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The drop-in pipeline pack: skills, hooks, setup, templates, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | | |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| ravintio-plan | `consistency-check.mjs` | CLI over `plan/current/` | exit 0 or 1 |
| Claude Code | `ratchet-check.mjs` | PreToolUse hook stdin | exit 0 or 2 |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js ESM, Bash, Markdown |
| Testing | Shell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A story mapping pass in the plan skill and a `story-map.template.md`.
- Gherkin criteria in `requirement.template.md` and the plan skill rules.
- New consistency-check rules for Gherkin structure and story map coverage.
- Ratchet guard for Gherkin step lines.

### Out of Scope
- Rewriting acceptance criteria in archived runs.
- Running Gherkin through a test framework such as Cucumber.
- Other backlog entries.

### Deferred
- Nothing deferred.
