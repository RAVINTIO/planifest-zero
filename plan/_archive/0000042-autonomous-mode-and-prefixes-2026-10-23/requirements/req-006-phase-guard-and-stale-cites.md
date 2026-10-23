---
title: "Requirement: req-006 - phase-guard-and-stale-cites"
summary: "Stale phase cites move to the new numbers, one override file is renamed, and a grep test blocks old numbers."
status: "active"
version: "0.1.0"
---
# Requirement: req-006 - phase-guard-and-stale-cites

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-003
**Priority:** must-have

## User Story

As a human on the loop, I read a phase number and name at the start of every message, such as `P2 Implement:`, so that I know where the run is without a legend.

## Functional Requirements

### Stale cites
- Stale cites move to the new numbers. Examples are "P0 briefing", P6, and P9. A cite to a phase that no longer exists is rewritten to name the right phase.
- `planifest-overrides/instructions/custom-004-p9-push-and-raise-pr.md` is renamed to `custom-004-ship-push-and-raise-pr.md`, and its text is renumbered.
  - Every reference to the old file name updates to the new one.

### Guard test
- A grep test fails when any of these cite a phase number outside P0 to P4, or a retired letter prefix:
  - Skills.
  - Docs.
  - Templates.
  - Hooks.
  - Standards.
- The test excludes these paths. They record history or belong to this run:
  - `plan/_archive/`
  - `plan/changelog/`
  - `planifest-zero/migrations/_done/`
  - Every entry under `plan/backlog/`. Entries are history-like, and telling old from new would need a fixed id list.
  - `plan/current/`
- The test prints each offending file and line.

### Exclusion
- This run's own build log at `plan/current/build-log.md` keeps P1 to P5 headings. The 0.8.0 skills drive this run and parse that form. The renumbering takes effect for the next feature.

## Acceptance Criteria
- [ ] (a) The grep test finds no `P5` to `P9`, no "Phase 0", and no retired letter prefix in skills, docs, templates, hooks, and standards. It exits 0.
- [ ] (b) With a planted `P6` in a skill file, the grep test exits non-zero and names the file. The same holds for a planted `PL:` prefix. The test ignores `plan/_archive/`, `plan/changelog/`, `planifest-zero/migrations/_done/`, existing backlog entries, and `plan/current/`, even when they hold old numbers.
- [ ] (c) `custom-004-p9-push-and-raise-pr.md` no longer exists. `custom-004-ship-push-and-raise-pr.md` exists with renumbered text. A grep for the old name finds nothing outside the excluded history.

## Dependencies
- REQ-004 renumbers the phases that the guard test checks.
- REQ-005 retires the letter prefixes that the guard test blocks.
- REQ-008 to REQ-010 (framework wording) edit some of the same files. Land the two sets of edits in separate commits.

## Files in reach

- `planifest-overrides/instructions/custom-004-p9-push-and-raise-pr.md` (rename, matches by name)
- Completed migrations under `planifest-zero/migrations/_done/` match the phase grep (`0002-british-english.md`, `migrate-adoption-mode-and-about-md.md`, `migrate-product-yml-component-paths.md`). They record history, so the guard test excludes them.
- A new test under `planifest-zero/tests/` holds the guard.
