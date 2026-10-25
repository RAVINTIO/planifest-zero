---
title: "Discovery - 0000170-story-mapping-and-gherkin"
summary: "Raw discovery-pass findings: what the orchestrator knew before drafting the design."
---
# Discovery - 0000170-story-mapping-and-gherkin

> Raw findings only. Decisions belong in `design.md`, the audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000170-story-mapping-and-gherkin` cut from `roadmap/0000168-backlog-clearance` at `ab676d8`. Roadmap step, per R-C Run. |
| Skills inbox | `ravintio-zero/skills-inbox/` holds no `SKILL.md` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.14.0`, from 0000169.
- Roadmap `0000168-backlog-clearance` is active at position 2. Step 2 takes backlog entry 0000165 with a minor bump.
- Roadmap schema and dependency tables list `none` for step 2.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). No component owns data.
- Repo instructions (`ravintio-overrides/instructions/`): `custom-001` to `custom-005`.
- Pending migration `0004-ravintio-rename.md` does not apply. This repo is the pack source.
- Strict mode is on (`plan/.orchestrator-strict`).

## Backlog findings

### 0000165: user story mapping and Gherkin acceptance criteria

- `ravintio-zero/skills/ravintio-plan/SKILL.md` derives one requirement file per user story. No step checks the stories for gaps.
- `ravintio-zero/templates/requirement.template.md` holds acceptance criteria as free-text `- [ ]` lines.
- `ravintio-zero/scripts/consistency-check.mjs` check 2 counts `- [ ]` and `- [x]` lines in `## Acceptance Criteria` and flags more than 3.
- `ravintio-zero/hooks/enforcement/ratchet-check.mjs` guards the same `- [ ]` lines while a loop is active. A Gherkin step line under a criterion would have no guard.
- `test-0000016-pipeline-governance.sh` and its regression copy hold a clean consistency-check fixture with plain criteria, and a ratchet fixture.
- `test-0000010-pack-quality-improvements.sh` checks that the template keeps `## Functional Requirements` and `## Acceptance Criteria`.
- The test writer maps one criterion to one test function. The P3 coverage table maps each criterion to a test. Both read criteria as units, so the unit stays the checkbox line.
- No pack file mentions a story map or Gherkin today.
