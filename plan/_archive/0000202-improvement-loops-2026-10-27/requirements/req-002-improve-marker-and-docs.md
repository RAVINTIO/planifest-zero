# Requirement: REQ-002 - Improve marker and living docs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I read one `Improve:` marker per cycle that names the finding, the change, and the suite result, so that I can measure the gain.

## Functional Requirements
- `ravintio-zero/standards/workflow-governance-standards.md` lists two `Improve:` marker forms under `## Marker lines`. One form records a change and one records an early stop.
- The standard states that `workflow-metrics.mjs` does not count `Improve:` markers.
- `ravintio-zero/component.yml` has a responsibility line for the improvement loop.
- `docs/architecture-overview.md` and `ravintio-zero/pipeline-reference.md` name the improvement loop beside the TDD trio.

## Acceptance Criteria
- [ ] AC-1: the standard lists both marker forms
  - Given the workflow governance standard
  - When a test reads its `## Marker lines` section
  - Then the section lists an `Improve:` form with a finding, a change, and a suite result, and an `Improve:` form for an early stop
- [ ] AC-2: the standard says the script ignores the marker
  - Given the workflow governance standard
  - When a test searches for the metrics note
  - Then the standard states that `workflow-metrics.mjs` does not count `Improve:` markers
- [ ] AC-3: the living docs name the loop
  - Given `component.yml`, the architecture overview, and the pipeline reference
  - When a test searches each file
  - Then each file names the improvement loop

## Dependencies
- REQ-001
