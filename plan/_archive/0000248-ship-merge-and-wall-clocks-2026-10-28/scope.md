---
title: "Scope - ship merge command and wall clock check"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - ship merge command and wall clock check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Version:** 0.37.0

## In Scope

- A plain merge line and its literal-number rule in `ravintio-ship/SKILL.md`, matched in I-D Advance step 4 of `roadmap-standards.md`.
- `ravintio-zero/scripts/build-log-check.mjs`, and a ship Step 3 instruction that runs it before Archive.
- A skipped-phase note in `build-log.template.md`.
- Two tests: `test-0000248-req-001-plain-merge-command.sh` and `test-0000248-req-002-build-log-wall-clock-check.sh`.
- Count updates in existing tests that this step's own additions break.
- Docs, changelog, and version updates for 0.37.0.

## Out of Scope

- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A change to `consistency-check.mjs`, which runs at P1 before phase blocks exist.
- A PowerShell twin of the script.

## Deferred

Nothing deferred.
