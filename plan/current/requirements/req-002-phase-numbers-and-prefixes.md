---
title: "Requirement: req-002 - phase-numbers-and-prefixes"
summary: "Phases renumber to P0 to P4, build-log headings and message prefixes carry the phase number, and a grep test blocks stale cites."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - phase-numbers-and-prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-003
**Priority:** must-have

## User Story

As a human on the loop, I read a phase number and name at the start of every message, such as `P2 Implement:`, so that I know where the run is without a legend.

## Functional Requirements

### Phase numbers
- The pipeline phases are numbered P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship.
- The new numbers replace the old ones in these places:
  - Skills, templates, and docs under `planifest-zero/` and `docs/`.
  - Hooks and standards under `planifest-zero/`.
  - Workflows under `planifest-zero/workflows/`.
  - `CLAUDE.md` at the repo root.
  - `planifest-overrides/instructions/`.
  - Tests under `planifest-zero/tests/`, which change their assertions and keep their file names.
- Prose that names a phase by its old number moves to the new number. The old P1 (Discovery) becomes P0, the old P2 (Plan) becomes P1, and so on up to the old P5 (Ship), which becomes P4.
- Skills and the build log keep the full name "Validate and Accept" for P3.

### Build-log headings
- Each build-log phase block starts with `### P<n>: {Phase Name}`, where `n` runs from 0 to 4.
- `planifest-zero/templates/build-log.template.md` uses this form.
- Orchestrator Hard Limit 10 uses this form and drops its claim that a hook parses the heading. No source hook does.

### Message prefixes
- Every message starts with one of these prefixes:

  | Phase | Prefix |
  |-------|--------|
  | P0 | `P0 Discovery:` |
  | P1 | `P1 Plan:` |
  | P2 | `P2 Implement:` |
  | P3 | `P3 Validate:` |
  | P4 | `P4 Ship:` |

- Messages use `P3 Validate:` while skills and the build log keep "Validate and Accept".
- Status messages use the form `{prefix} {Status}: {one-liner}`. The status is one of Starting, Resuming, Complete, Blocked, or Skipped. An example is `P1 Plan: Complete: 4 requirements, 2 ADRs`.
- The letter prefixes `D:`, `PL:`, `IM:`, `VA:`, and `SH:` are retired. No skill, doc, template, hook, or standard uses them.
- The orchestrator prefix table and the "Phase Indicators" section of `planifest-zero/pipeline-reference.md` both use the one status form. Today the orchestrator uses a colon after the status and the reference uses a comma.

### Stale cites
- Stale cites move to the new numbers. Examples are "P0 briefing", P6, and P9. A cite to a phase that no longer exists is rewritten to name the right phase.
- `planifest-overrides/instructions/custom-004-p9-push-and-raise-pr.md` is renamed to `custom-004-ship-push-and-raise-pr.md`, and its text is renumbered.
  - Every reference to the old file name updates to the new one.
- Hook messages that say "Phase 0" in `check-design.mjs` and `gate-write.mjs` use the new "P0 Discovery" wording.
- The "Source phase" placeholder in `planifest-zero/templates/backlog-entry.template.md` offers P0 to P4.

### Guard test
- A grep test fails when any of these cite a phase number outside P0 to P4, or a retired letter prefix:
  - Skills.
  - Docs.
  - Templates.
  - Hooks.
  - Standards.
- The test excludes `plan/_archive/`, `plan/changelog/`, and existing backlog entries. These record history.
- The test prints each offending file and line.

### Exclusion
- This run's own build log at `plan/current/build-log.md` keeps P1 to P5 headings. The 0.8.0 skills drive this run and parse that form. The renumbering takes effect for the next feature.

## Acceptance Criteria
- [ ] (a) The grep test finds no `P5` to `P9`, no "Phase 0", and no retired letter prefix in skills, docs, templates, hooks, and standards. It exits 0.
- [ ] (b) With a planted `P6` in a skill file, the grep test exits non-zero and names the file. The same holds for a planted `PL:` prefix.
- [ ] (c) The grep test ignores `plan/_archive/`, `plan/changelog/`, and existing backlog entries, even when they hold old numbers.
- [ ] (d) `build-log.template.md` and orchestrator Hard Limit 10 use `### P<n>: {Phase Name}` with n from 0 to 4. Hard Limit 10 makes no claim that a hook parses the heading.
- [ ] (e) The orchestrator prefix table and `pipeline-reference.md` "Phase Indicators" list the same five prefixes and the same `{prefix} {Status}: {one-liner}` form with the five statuses.
- [ ] (f) `custom-004-p9-push-and-raise-pr.md` no longer exists. `custom-004-ship-push-and-raise-pr.md` exists with renumbered text. A grep for the old name finds nothing outside the excluded history.
- [ ] (g) `check-design.mjs` and `gate-write.mjs` messages say "P0 Discovery" and not "Phase 0".
- [ ] (h) The backlog-entry template "Source phase" placeholder reads P0 to P4.
- [ ] (i) The existing test suite passes after the renumbering, with assertions updated to the new numbers.

## Dependencies
- req-001 covers run modes. Its gate wording uses the new numbers, so the two requirements land in the same release.
- The design section "Phase numbers and prefixes" fixes the prefix table and the Hard Limit 10 change.
- The "framework" wording requirement edits some of the same files. Land the two sets of edits in separate commits.

## Files in reach

Inventory from `grep -rlE "\bP[0-9]\b|Phase [0-9]"` and a grep for the letter prefixes over `planifest-zero/`, `CLAUDE.md`, `README.md`, `docs/`, and `planifest-overrides/`. It excludes `plan/_archive/` and `plan/changelog/`. The plan phase confirms the list when it writes the execution plan.

Non-test files (28):
- `CLAUDE.md`
- `docs/decisions-index.md`
- `planifest-overrides/instructions/custom-003-git-up-to-date-shorthand.md`
- `planifest-overrides/instructions/custom-004-p9-push-and-raise-pr.md` (rename, matches by name)
- `planifest-zero/hooks/enforcement/check-design.mjs`
- `planifest-zero/hooks/enforcement/gate-write.mjs`
- `planifest-zero/hooks/enforcement/ratchet-check.mjs`
- `planifest-zero/pipeline-reference.md`
- `planifest-zero/scripts/refresh-delete-boot-files.ps1`
- `planifest-zero/scripts/refresh-delete-boot-files.sh`
- `planifest-zero/setup.ps1`
- `planifest-zero/setup.sh`
- `planifest-zero/skills/planifest-orchestrator/SKILL.md`
- Templates under `planifest-zero/templates/`:
  - `adr-guide.md`
  - `backlog-entry.template.md`
  - `build-log.template.md`
  - `data-contract-guide.md`
  - `discovery.template.md`
  - `domain-glossary-guide.md`
  - `execution-plan-guide.md`
  - `iteration-log.template.md`
  - `loop-state.template.md`
  - `park.template.md`
  - `product.template.yml`
  - `risk-register-guide.md`
  - `scope-guide.md`
  - `standard-boot.md`
  - `test-report.template.md`
- Completed migrations under `planifest-zero/migrations/_done/` match too (`0002-british-english.md`, `migrate-adoption-mode-and-about-md.md`, `migrate-product-yml-component-paths.md`). They record history, so the plan phase decides whether the guard test excludes them.

Tests: 23 files under `planifest-zero/tests/` match. They change assertions only. A further new test holds the guard.
