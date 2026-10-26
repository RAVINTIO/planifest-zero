---
title: "Scope - name-the-roadmap-initiative"
summary: "Boundaries for the roadmap initiative rename, the glossary, migration 0005, and the old-name guard."
status: "draft"
version: "0.1.0"
---
# Scope - name-the-roadmap-initiative

**Skill:** plan
**Feature:** 0000189-name-the-roadmap-initiative
**Version:** 0.19.0

## In Scope

- The glossary entry for "roadmap" and "roadmap initiative", with an explanation in `ravintio-zero/project-operations.md`.
- Every rename in the Names table of `plan/current/design.md`, in each file that uses an old name, including `CLAUDE.md` and `ravintio-overrides/instructions/`.
- Activation moves an initiative to `plan/current-initiative/initiative.md`.
- Stage prefixes `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, and `I-E Delivery:`.
- Template status set to `proposed | charted | active | delivered | blocked`.
- Prose in skills, standards, templates, and docs that uses "initiative" for the charted unit.
- Migration `0005`, which stops while `plan/current-roadmap/` exists.
- The driver stops and names the new variable when an old `RAVINTIO_ROADMAP_*` variable is set.
- A search test that fails on old names outside an allowlist.
- New wording in the open backlog entries 0000174 to 0000186.
- Refreshing `.claude/skills/` from `ravintio-zero/skills/` after P2. The human pre-approved this at P0 (US-008).

## Out of Scope

- The `ravintio-initiative` skill and its progress reports (backlog 0000182).
- New prefix enforcement, such as a `Stop` hook (backlog 0000181).
- Aliases for the old names.
- Renaming `roadmap-standards.md` or historical test files.
- Editing `plan/_archive/` or `plan/changelog/`.

## Deferred

Nothing deferred.
