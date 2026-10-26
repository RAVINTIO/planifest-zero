---
title: "Discovery - 0000189-name-the-roadmap-initiative"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000189-name-the-roadmap-initiative

> Created at the start of discovery (P0), before the first coaching question.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs, the latest 0000185-explain-strict-mode` |
| Git pre-flight | `feat/0000189-name-the-roadmap-initiative, cut from main at 6c948a7 after PR #36 merged; main up to date` |
| Skills inbox | `empty (.gitkeep only)` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`, `docs/about.md`): `0.18.1`
- Prior features (`plan/_archive/`): 0000043-autonomous-roadmaps (introduced roadmaps), 0000151-hardening-efficiency-and-ci (driver step logs, telemetry labels, model and turn cap), 0000168-backlog-clearance roadmap (first delivered roadmap, v0.14.0 to v0.18.1), latest 0000185-explain-strict-mode.
- Constraining ADRs (unless superseded):
  - 0000043 ADR-002 roadmap storage and lifecycle (`plan/roadmap/` drafts, `plan/current-roadmap/` active, archive at delivery)
  - 0000043 ADR-003 agent squash merge into `roadmap/*` branches (merge-guard hook)
  - 0000043 ADR-004 driver script, fresh session per step
  - 0000043 ADR-006 self-confirmed roadmap steps and the R-A to R-E prefixes
  - 0000151 ADR-005 roadmap driver child contract
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns all pack files. No datasets or schema.
- Repo instructions (`ravintio-overrides/instructions/`): custom-001 to custom-005 (local git, subagent decomposition, GUTD, ship pushes and raises PR, delete redundant branches).
- Strict mode: `plan/.orchestrator-strict` present. Ack written with this session's id.
- Release size: `releaseSize` absent from `product.yml`, so the budget is `medium` (8 points).

## Backlog

- Pulled in: 0000188-name-the-roadmap-initiative.
- Left open for the roadmap initiative charted on 2026-10-25: 0000174 to 0000183 and 0000186.

## "Roadmap" usage outside `plan/`

- 60 tracked files mention "roadmap", 722 mentions in total.
- Named files: `ravintio-zero/scripts/roadmap-run.mjs`, `roadmap-labels.mjs`, `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/templates/roadmap-entry.template.md`, and 11 tests named `test-0000043-*roadmap*` or `test-0000151-*roadmap*`.
- Heaviest: `roadmap-standards.md` (58), `roadmap-run.mjs` (44), merge-guard test (40), step-log test (32), driver test (28).
- Names in use: branch `roadmap/{id}-{slug}`; folders `plan/roadmap/`, `plan/current-roadmap/`, `plan/.roadmap-logs/`; file `roadmap.md`; env vars `RAVINTIO_ROADMAP_MODEL` and `RAVINTIO_ROADMAP_MAX_TURNS`; telemetry labels `work.kind=roadmap`, `ravintio.roadmap`, `ravintio.step`; prefixes `R-A` to `R-E`.
- `.claude/skills/` is the installed copy of `ravintio-zero/skills/` and differs from it today, so setup must run after the change.
