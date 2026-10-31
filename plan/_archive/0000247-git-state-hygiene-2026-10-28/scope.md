---
title: "Scope - git state hygiene"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - git state hygiene

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Version:** 0.36.0

## In Scope

- A staging rule in `ravintio-orchestrator/SKILL.md` and `ravintio-ship/SKILL.md`.
- A `--commit` flag on `reserve-id.mjs` and the commit rule in the initiative, retrospective, and postmortem skills.
- A `git stash` rule in `agent-dispatch-standards.md` and in its skeleton prompts.
- Three tests: `test-0000247-req-001-stage-by-path.sh`, `test-0000247-req-002-commit-id-reservations.sh`, `test-0000247-req-003-no-stash-in-batch.sh`.
- Count updates in existing tests that this step's own additions break.
- Docs, changelog, and version updates for 0.36.0.

## Out of Scope

- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A PowerShell twin of `reserve-id.mjs`.

## Deferred

Nothing deferred.
