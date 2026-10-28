---
title: "Scope - initiative mid-run changes"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - initiative mid-run changes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000250-initiative-mid-run-changes
**Version:** 0.39.0

## In Scope

- A routing rule and a restart rule in `ravintio-initiative/SKILL.md`.
- A change check and a restart stop in `initiative-run.mjs`.
- The same rules in `roadmap-standards.md` and the driver header comment.
- Two tests: `test-0000250-req-001-routing-and-restart-rules.sh` and `test-0000250-req-002-driver-restart-stop.sh`.
- Docs, changelog, and version updates for 0.39.0.

## Out of Scope

- A driver that restarts itself in a new process.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A change to `initiative-watch.mjs`.
- A check for changes to other files, such as the orchestrator skill.

## Deferred

Nothing deferred.
