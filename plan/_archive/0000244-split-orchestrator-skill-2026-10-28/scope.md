---
title: "Scope - split the orchestrator skill"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - split the orchestrator skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Version:** 0.33.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Move six task-bound sections into new `references/orchestrator-*.md` files, line for line.
- Move the initiative stage prefix block to `roadmap-standards.md`.
- Replace the Pack Index template rows with one rule and add one row per new reference file.
- Set the `SKILL.md` cap to 9,000 bytes and update the tests that read moved lines.

## Out of Scope

- The combined `CLAUDE.md` plus `SKILL.md` cap and the size of `CLAUDE.md`.
- Any wording change to a moved line.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.

## Deferred

Nothing deferred.
