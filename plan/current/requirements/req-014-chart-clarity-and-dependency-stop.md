---
title: "Requirement: req-014 - chart-clarity-and-dependency-stop"
summary: "Chart checks each backlog entry is clear and collects approved dependencies, and a new exception stop fires in every run for an unapproved library or service."
status: "draft"
version: "0.1.0"
---
# Requirement: req-014 - chart-clarity-and-dependency-stop

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-009 (backlog 0000147)
**Priority:** should-have

## User Story

As a maintainer charting a roadmap, I sharpen vague entries and approve new dependencies up front, so that steps stop less while I am away.

## Functional Requirements
- R-A Chart in `planifest-zero/standards/roadmap-standards.md` gains a clarity check.
  - For each backlog entry of each step, Chart checks that the entry states a problem, a wanted outcome, and one observable condition that P0 can turn into an acceptance criterion.
  - Chart lists each entry that fails the check and asks the human to sharpen it or strike the step.
  - The human's confirmation of the chart covers only entries that pass or that the human sharpens.
  - Chart never rewrites an entry itself.
- R-A Chart gains a dependency survey, placed after the schema approval section and in the same style.
  - Chart reads each step's entries and the manifests of the components they touch, and predicts each library or service the step adds.
  - Chart writes one row per prediction in a `## Dependencies` table in `roadmap.md`. A step with no prediction gets one row with Kind `none`.
  - The human approves, edits, or strikes each row. Confirming the chart approves every row left.
  - Chart asks no fallback question. A dependency that no row lists stops the step.
- `planifest-zero/templates/roadmap-entry.template.md` gains a `## Dependencies` section next to `## Schema changes`.
  - The columns are Step, Name, Kind (`library`, `service`, or `none`), and Purpose.
  - The header note points to the new standards section.
- `planifest-zero/templates/design.template.md` gains an `Approved dependencies` field under its `## Dependencies` section.
  - The field lists each library or service the feature may add, or `none`.
  - In a roadmap step, P0 copies that step's rows from `roadmap.md` into the field. The stop check still reads `roadmap.md`.
- The Exception Stops table in `planifest-zero/skills/planifest-orchestrator/SKILL.md` gains a sixth row.
  - It fires in every run mode when P1 or P2 adds a library or service that is not on the approved list.
  - The list is the design's `Approved dependencies` field in an interactive run and the roadmap's `## Dependencies` table in a roadmap step.
  - The message is `{prefix} Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative.`
  - The row follows the shared stop steps, including the `Blocked:` and `Resolved:` build-log lines.
  - When the human approves, the run adds the name to the same list and logs the decision in the `Resolved:` line.
- `planifest-implement` and `planifest-plan` mirror the wording where they cover new libraries.
  - `planifest-implement` states the stop beside the dependency-manifest audit paragraph.
  - `planifest-plan` states the stop beside the "Deviates from the declared stack" ADR criterion.
- No existing stop, library audit, or ADR rule changes or weakens.

## Acceptance Criteria
- [ ] (a) `roadmap-standards.md` has a clarity check under R-A Chart that names the three things an entry states, and says the human sharpens or strikes a failing entry.
- [ ] (b) `roadmap-standards.md` has a dependency survey section that names the `## Dependencies` table, the three kinds, the `none` row, and the rule that an unlisted dependency stops the step.
- [ ] (c) `roadmap-entry.template.md` has a `## Dependencies` heading after `## Schema changes` with the four columns, and a `none` example row.
- [ ] (d) `design.template.md` has an `Approved dependencies` field under `## Dependencies`.
- [ ] (e) The Exception Stops table in the orchestrator `SKILL.md` has six rows. The sixth names both lists and states that it applies to both run modes.
- [ ] (f) The sixth row's message uses the `Blocked:` form and names the new dependency.
- [ ] (g) `planifest-implement/SKILL.md` and `planifest-plan/SKILL.md` each contain the dependency stop wording and name both lists.
- [ ] (h) The five original Exception Stops rows are byte-identical to their text before the change.
- [ ] (i) The existing roadmap-chart tests still pass, including `test-0000043-req-002-roadmap-chart.sh` and `test-0000043-req-011-chart-time-schema-approval.sh`.
- [ ] (j) The installed copies under `.claude/skills/` match the sources after setup reruns.

## Dependencies
- Chart-time schema approval in `roadmap-standards.md` is the pattern this requirement follows.
- REQ-011 (orchestrator references split) may move orchestrator sections. The Exception Stops table stays in `SKILL.md`, so the sixth row lands in the same place either way.
- Files in reach:
  - `planifest-zero/standards/roadmap-standards.md` (Chart at lines 30 to 48, schema approval at 50 to 70)
  - `planifest-zero/templates/roadmap-entry.template.md`
  - `planifest-zero/templates/design.template.md`
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (Exception Stops, about lines 413 to 435)
  - `planifest-zero/skills/planifest-implement/SKILL.md` (dependency manifest paragraph, line 44)
  - `planifest-zero/skills/planifest-plan/SKILL.md` (ADR criteria, line 66)
  - `planifest-zero/tests/test-0000151-req-014-chart-clarity-and-dependency-stop.sh` (new, prose checks with `grep` on the files above)
