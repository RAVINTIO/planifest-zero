---
title: "Discovery - 0000172-subagent-acceleration"
summary: "Raw discovery-pass findings: what the orchestrator knew before drafting the design."
---
# Discovery - 0000172-subagent-acceleration

> Raw findings only. Decisions belong in `design.md`, the audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000172-subagent-acceleration` cut from `roadmap/0000168-backlog-clearance` at `1a14101`. Roadmap step, per R-C Run. |
| Skills inbox | `ravintio-zero/skills-inbox/` holds no `SKILL.md` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.16.0`, from 0000171.
- Roadmap `0000168-backlog-clearance` is active at position 4. Step 4 takes backlog entry 0000110 with a minor bump.
- Roadmap schema and dependency tables list `none` for step 4.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). No component owns data.
- Repo instructions (`ravintio-overrides/instructions/`): `custom-001` to `custom-005`.
- Pending migration `0004-ravintio-rename.md` does not apply. This repo is the pack source.
- Strict mode is on (`plan/.orchestrator-strict`).

## Backlog findings

### 0000110: subagent acceleration

- `plan/.run-mode` accepts only `gated` or `autonomous`. The orchestrator, the validate skill, the ship skill, `pipeline-reference.md`, and `workflows/feature-pipeline.md` all read it. The 0000042 run-mode suites check the two-value rule.
- `ravintio-zero/standards/agent-dispatch-standards.md` holds the parallelism rules. Its default posture is already parallel, but each phase decides its own batches.
- Each phase skill has its own parallelism section: plan (`## Parallelism`), implement (`## Parallel dispatch`), validate (`## Parallelism`). The ship skill has none.
- The build-log template phase block records `Agents spawned` and `Parallel task batches`. It records a `Start` time but no end time or wall-clock time.
- The ship skill's build assessment (Step 5) reads agent counts and parallelism from the build log.
- The roadmap template has no speed field. The driver `roadmap-run.mjs` reads `Position` and the step table.
