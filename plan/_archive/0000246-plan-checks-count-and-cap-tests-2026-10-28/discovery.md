---
title: "Discovery - 0000246-plan-checks-count-and-cap-tests"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000246-plan-checks-count-and-cap-tests

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000246-plan-checks-count-and-cap-tests`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.34.0`.
- Prior features: 0000243, 0000244, 0000245, all archived 2026-10-28.
- Constraining ADRs: none touch the plan skill.
- Component map: one component, `ravintio-zero`.
- Backlog entry: 0000210. The plan skill (`ravintio-zero/skills/ravintio-plan/SKILL.md`, 9,652 bytes) has no step that scans tests.
- Tests that hold the counts, budgets, caps and ids:
  - Skill count: `test-0000160-req-001-pack-identifiers.sh` (16 skills), `test-0000031-req-003-five-phases.sh` (skill directory count).
  - Skill text budget: `test-0000031-req-003-five-phases.sh` (1,720 lines, 35 lines of headroom on 2026-10-28).
  - Size caps: `test-0000151-req-011-orchestrator-references-split.sh` and `.ps1` (orchestrator `SKILL.md` at 9,000 bytes).
  - Entry ids: `test-0000189-req-008-open-backlog-entries.sh` (entries 0000178, 0000181, 0000182).
- Version: chart sets a minor bump, so 0.35.0.

## Past retrospectives

- 0000245: moved text breaks tests that read the old location. Move text verbatim and check against a fixture.
- 0000204: the source retrospective for entry 0000210. Three rework loops from tests the plan never named.
