---
title: "Scope - session start detection"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - session start detection

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Version:** 0.32.0

## In Scope

- The `resume-detect.mjs` script and its fixture tests.
- The hook change that runs it and injects its lines or the failure line.
- The reference file and the short Resume Detection rule in `SKILL.md`.
- The initiative skill reading the same findings.

## Out of Scope

- Splitting the rest of the orchestrator `SKILL.md`, which step 6 does.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- The strict-mode hook beyond keeping its initiative rule in step.

## Deferred

- Nothing deferred.
