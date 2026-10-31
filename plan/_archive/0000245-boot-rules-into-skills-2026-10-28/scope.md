---
title: "Scope - boot rules into skills"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - boot rules into skills

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Version:** 0.34.0

## In Scope

- A Hook Enforcement reference file, boot template pointers, and block messages that name the file.
- `target:` frontmatter handling in `setup.sh` and `setup.ps1`.
- Capability skills `gutd` and `delete-redundant-branches`, and retargeted overrides 002, 004, and 006.
- A 6,000-byte test for the generated `CLAUDE.md`, and the `test-0000151-req-014` change.

## Out of Scope

- Regenerating this repo's `CLAUDE.md` and `.claude/skills/` (step 15).
- Any change to what `merge-guard`, `gate-write`, or another hook allows.
- Codex install paths beyond the shared boot template pointer.

## Deferred

Nothing deferred.
