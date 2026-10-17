---
title: "Recommendations - 0000037-self-host-on-planifest-zero"
summary: "P6 recommendations, deferred items, and tech debt filed for this feature."
status: "draft"
version: "0.1.0"
---
# Recommendations - 0000037-self-host-on-planifest-zero

**Skill:** [docs-agent](../../.claude/skills/planifest-docs-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Date:** 2026-10-17

## Deferred Items

| Item | Reference | Status |
|------|-----------|--------|
| The local reinstall of `.claude/` and `CLAUDE.md` with `planifest-zero/setup.sh claude-code`. | Scope Deferred section, ADR-001 decision 5. | Not filed. It is a human step after merge, not future feature work. |

## Tech Debt

| Item | Reference | Status |
|------|-----------|--------|
| None | n/a | n/a |

## Recommendations

- Run the reinstall first after merge. Until then, sessions load the old ten-phase skills and the orchestrator doesn't load on its own.
- Pick up backlog 0000111 next. It closes the last known filter gap between `setup.sh` and `setup.ps1`.
- After the reinstall, reassess backlog 0000095. This repo's own install was the last known reason to keep the legacy telemetry cleanup.
- `planifest-zero/hooks/planifest.yml`, the workflow that setup ships to consumer repos, has no `permissions: contents: read` block. The repo's own `.github/workflows/planifest.yml` gained one in 0000036. Consider the same default for consumers.

## Deliberate Absence: No per-component `docs/` folder

`planifest-zero/` is the single component and the product itself. `planifest-zero/component.yml` and the living docs carry the per-component role.

## Other Notes for the Ship Agent

- `product.yml`, `planifest-zero/component.yml`, and `docs/about.md` already read `0.5.0` and `0000037-self-host-on-planifest-zero`.
- `docs/about.md` had a body table that still read `0.4.1` and `0000034-setup-hardening`. P6 corrected it with the frontmatter.
