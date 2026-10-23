---
title: "Requirement: req-004 - phase-numbers-p0-to-p4"
summary: "Phases renumber to P0 to P4 across the framework, and build-log headings carry the phase number."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - phase-numbers-p0-to-p4

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

### Hook messages and templates
- Hook messages that say "Phase 0" in `check-design.mjs` and `gate-write.mjs` use the new "P0 Discovery" wording.
- The "Source phase" placeholder in `planifest-zero/templates/backlog-entry.template.md` offers P0 to P4.

## Acceptance Criteria
- [ ] (a) `build-log.template.md` and orchestrator Hard Limit 10 use `### P<n>: {Phase Name}` with n from 0 to 4. Hard Limit 10 makes no claim that a hook parses the heading.
- [ ] (b) `check-design.mjs` and `gate-write.mjs` messages say "P0 Discovery" and not "Phase 0". The backlog-entry template "Source phase" placeholder reads P0 to P4.
- [ ] (c) The existing test suite passes after the renumbering, with assertions updated to the new numbers.

## Dependencies
- REQ-001 to REQ-003 cover run modes. Their gate wording uses the new numbers, so the requirements land in the same release.
- The design section "Phase numbers and prefixes" fixes the Hard Limit 10 change.
- REQ-005 sets the message prefixes and REQ-006 guards against stale cites.
- REQ-008 to REQ-010 (framework wording) edit some of the same files. Land the two sets of edits in separate commits.

## Files in reach

Inventory from `grep -rlE "\bP[0-9]\b|Phase [0-9]"` over `planifest-zero/`, `CLAUDE.md`, `README.md`, `docs/`, and `planifest-overrides/`. It excludes `plan/_archive/` and `plan/changelog/`. The plan phase confirms the list when it writes the execution plan.

Non-test files:
- `CLAUDE.md`
- `docs/decisions-index.md`
- `planifest-overrides/instructions/custom-003-git-up-to-date-shorthand.md`
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

Tests: 23 files under `planifest-zero/tests/` match. They change assertions only.
