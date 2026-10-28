---
title: "Scope - size cap excludes overrides"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - size cap excludes overrides

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Version:** 0.31.2

## In Scope

- Strip the override block from `CLAUDE.md` before the size cap test counts it.
- Set the combined cap to 32,800 bytes.
- Tests for an added override and for pack growth.

## Out of Scope

- The separate `SKILL.md` cap, which step 6 changes.
- The `CLAUDE.md` cap, which step 7 changes.
- `setup.sh`, `setup.ps1`, and the boot templates.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.

## Deferred

- Nothing deferred.
