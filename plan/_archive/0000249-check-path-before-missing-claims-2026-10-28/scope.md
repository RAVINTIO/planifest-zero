---
title: "Scope - PATH check before a missing-program claim"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - PATH check before a missing-program claim

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000249-check-path-before-missing-claims
**Version:** 0.38.0

## In Scope

- A `PATH` search rule, the common install folders, and the `unverified (docs only)` status in `ravintio-validate-and-accept/SKILL.md`.
- Acceptance evidence rules for the search commands and the list of unverified claims.
- One test: `test-0000249-req-001-path-check-and-docs-only-status.sh`.
- Docs, changelog, and version updates for 0.38.0.

## Out of Scope

- A script that runs the search for the agent.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A change to the verification report or acceptance evidence templates.

## Deferred

Nothing deferred.
