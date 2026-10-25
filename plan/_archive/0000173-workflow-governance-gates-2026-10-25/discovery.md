---
title: "Discovery - 0000173-workflow-governance-gates"
summary: "Raw discovery-pass findings: what the orchestrator knew before drafting the design."
---
# Discovery - 0000173-workflow-governance-gates

> Raw findings only. Decisions belong in `design.md`, the audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000173-workflow-governance-gates` cut from `roadmap/0000168-backlog-clearance` at `2259559`. Roadmap step, per R-C Run. |
| Skills inbox | `ravintio-zero/skills-inbox/` holds no `SKILL.md` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.17.0`, from 0000172.
- Roadmap `0000168-backlog-clearance` is active at position 5. Step 5 takes backlog entry 0000100 with a minor bump.
- The roadmap has no `**Speed:**` field, so the run speed is `standard`.
- Roadmap schema and dependency tables list `none` for step 5.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). No component owns data.
- Repo instructions (`ravintio-overrides/instructions/`): `custom-001` to `custom-005`.
- Pending migration `0004-ravintio-rename.md` does not apply. This repo is the pack source.
- Strict mode is on (`plan/.orchestrator-strict`).

## Backlog findings

### 0000100: workflow quality and governance gates

- The entry's **Wanted outcome** names four metrics: rework loops per requirement, `Blocked:` stops, mid-pipeline design changes, and human corrections at gates.
- The gate reports breaches in the build assessment and the PR description. It never blocks.
- The evaluation suite is out of scope. Backlog entry 0000174 holds it.
- The build log already records `Blocked: {exception} ({timestamp})` lines, per Exception Stops in the orchestrator skill.
- The build log records `Gate accepted: P{N}` lines in a gated run. It records no line when the human asks for a revision at a gate.
- The mid-pipeline change reference asks for a "Requirement Change" entry in the build log, with no fixed line form.
- Loop-state files (`plan/current/loop-state-{loop-id}.md`) hold one record per loop iteration. No record names a requirement in a fixed form.
- The build log has no fixed line for a requirement that goes back through the TDD loop.
- Ship Step 5 writes `build-report.md` from the archived build log. Ship Step 9 writes the PR body.
- `ravintio-zero/scripts/` holds Node scripts with Bash suites under `ravintio-zero/tests/`. Node needs no new dependency.
