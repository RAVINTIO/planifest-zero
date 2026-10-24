---
title: "Scope - autonomous-roadmaps"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.9.0"
---
# Scope - autonomous-roadmaps

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Version:** 0.9.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Roadmap drafts, `roadmap-entry.template.md`, and shared ids
- R-A Chart to R-E Delivery and their prefixes
- `plan/current-roadmap/`
- Self-confirmed P0 for roadmap steps, with a per-step bump
- PR against `roadmap/*`, squash merge after green CI, tag after merge
- merge-guard, registered by `setup.sh` and `setup.ps1`
- `roadmap-run.mjs` with a lock file, offered by R-B Activate
- Carve-out text in `custom-001-local-git-only.md`, `custom-004-ship-push-and-raise-pr.md`, and the orchestrator's merge rule
- Acceptance test in a throwaway repo in the `planifest` organisation

## Out of Scope

- A local-git merge path for repos with no remote
- Merging the roadmap PR into `main`
- More than one active roadmap per working tree
- Scheduled cloud routines as a chain runner

## Deferred

- Workflow quality gates (backlog 0000100). Blocked: nothing.
- Subagent acceleration (backlog 0000110). Blocked: nothing.
