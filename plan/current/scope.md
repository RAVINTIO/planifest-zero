---
title: "Scope - subagent-acceleration"
summary: "Boundaries for the run speed setting, fast batches per phase, and phase timing in the build log."
status: "draft"
version: "0.17.0"
---
# Scope - subagent-acceleration

**Skill:** plan
**Feature:** 0000172-subagent-acceleration
**Version:** 0.17.0

## In Scope

- The orchestrator asks a run-speed question after the run-mode question. It writes `plan/.run-speed` (REQ-001, ADR-002).
- A roadmap step takes the roadmap's `**Speed:**` field. When the field is absent, the step uses `standard`.
- The dispatch standards define the fast batch and its rules (REQ-002, ADR-003).
- The plan, implement, validate-and-accept, and ship skills each list their fast batch units (REQ-002, ADR-003).
- The ship skill deletes `plan/.run-speed` with the other sentinels (REQ-001).
- The build-log template records `End` and `Wall clock` for each phase. It also records the run speed in the header (REQ-003).
- The build report lists `End`, `Wall clock`, and the agent count for each phase (REQ-003).
- The pack version moves to 0.17.0, a minor release.

## Out of Scope

- Overlapping phases, and per-requirement streams that run across phases.
- A `fast` value in `plan/.run-mode`.
- Any change to the roadmap driver script.
- Other backlog entries.
- A wall-clock comparison between fast and standard runs. The build log gains the data, and a later release can compare it.

## Deferred

Nothing deferred.
