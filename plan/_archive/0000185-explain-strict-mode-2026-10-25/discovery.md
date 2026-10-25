---
title: "Discovery - 0000185-explain-strict-mode"
summary: "Raw discovery-pass findings: what the orchestrator knew before drafting the design."
---
# Discovery - 0000185-explain-strict-mode

> Raw findings only. Decisions belong in `design.md`, the audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000185-explain-strict-mode` cut from `roadmap/0000168-backlog-clearance` at `fc302f0`. Roadmap step, per R-C Run. |
| Skills inbox | `ravintio-zero/skills-inbox/` holds no `SKILL.md` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.18.0`, from 0000173.
- Roadmap `0000168-backlog-clearance` is active at position 6. Step 6 takes backlog entry 0000184 with a patch bump.
- The roadmap has no `**Speed:**` field, so the run speed is `standard`.
- Roadmap schema and dependency tables list `none` for step 6.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). No component owns data.
- Repo instructions (`ravintio-overrides/instructions/`): `custom-001` to `custom-005`.
- Pending migration `0004-ravintio-rename.md` does not apply. This repo is the pack source.
- Strict mode is on (`plan/.orchestrator-strict`). No hook banner carried a session id into this session, so the ack holds the UTC timestamp.

## Backlog findings

### 0000184: explain strict mode and the acknowledgement file

- The entry asks for a new subsection after the **Orchestrator Sentinel** table in `ravintio-zero/project-operations.md`.
- `project-operations.md` already holds a `## Strict Orchestrator Mode` section straight after **Orchestrator Sentinel**. It names both files and the flag in one paragraph. It does not say what the ack file holds, why it has that name, or what to do in a roadmap run.
- `ravintio-zero/pipeline-reference.md` holds a longer `## Strict Orchestrator Mode` section with a `### The ack file` subsection. It covers the timestamp fallback.
- `getting-started.md` links "Orchestrator sentinel and strict mode" to `project-operations.md#orchestrator-sentinel`, not to the strict mode section.
- The `README.md` `--strict-orchestrator` row has no link.
- The hook `ravintio-zero/hooks/enforcement/check-orchestrator-presence.mjs` acts only while `plan/.orchestrator-active` exists. The entry's draft text omits that condition.
- When the hook gets no session id, the banner asks for the current timestamp. The entry's draft text omits that fallback.
- The repo has no standing domain glossary. Each run writes `plan/current/domain-glossary.md`, which ship archives.
