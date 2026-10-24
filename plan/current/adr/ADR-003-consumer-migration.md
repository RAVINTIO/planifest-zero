---
title: "ADR 003: Consumer migration 0004"
summary: "Migration 0004 moves consumer overrides, workflow, and markers to the new names, using Bash and PowerShell helpers. Setup stops when old folders remain, and pruning removes old skill folders."
status: "accepted"
version: "0.1.0"
---
# ADR-003 - Consumer migration 0004

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Component:** ravintio-zero
**Date:** 2026-10-24

## Context

Consumers copy the pack folder into their repo and run setup. No install command downloads it. The rename leaves four things in a consumer repo that setup does not handle:

- the old `planifest-zero/` folder
- the user content in `planifest-overrides/`
- the installed `.github/workflows/planifest.yml`, which setup never overwrites
- the old marker files

Setup already re-sets `core.hooksPath` on each run. `prune_retired_skills` and `Remove-RetiredSkills` already delete installed skill folders that the pack no longer ships. The migration mechanism is a file in `migrations/*.md` plus helper scripts, run by the migrator skill. Migration 0003 is the precedent.

A consumer who runs the new setup before the migration risks a half-moved install.

## Decision

### Migration 0004

Ship `migrations/0004-ravintio-rename.md` with two helpers: `migrate-ravintio-rename.sh` and `migrate-ravintio-rename.ps1`. The helpers do the same work.

1. Move `planifest-overrides/` to `ravintio-overrides/`. The markers live in the generated boot file, and setup rewrites it on every run, so the helper leaves them alone.
2. Move `.github/workflows/planifest.yml` to `.github/workflows/ravintio.yml` and rewrite the `planifest-zero/` paths inside it.
3. Remove the old marker files `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`. No install writes a `.planifest-session` file, so the helper does not look for one.
4. Remove the old `planifest-zero/` folder after the consumer has copied in the new `ravintio-zero/` pack.
5. After a run that changes the repo, move `0004-ravintio-rename.md` to `migrations/_done/`.

### Applies when

Migration 0004 declares `Applies when:` `planifest-zero/` or `planifest-overrides/` exists. The orchestrator and `ravintio-migrator` skip a migration whose condition is false and leave it pending. The pack source repo has neither folder, so 0004 ships pending and never runs there.

### Safety rules

- Each step is idempotent. A second run finds nothing to do and exits cleanly.
- If a step finds a conflict, the helper stops before it moves anything. A conflict is an existing target with different content.
- The helpers refuse a symlinked source or target. They never follow a planted link, as setup does.
- The helper reports each step it takes and each step it skips.

### Setup behaviour

If setup finds a `planifest-zero/` or `planifest-overrides/` folder, it stops. It tells the consumer to run migration 0004 first. Setup makes no changes in that case.

Once the pack ships only `ravintio-*` skills, `prune_retired_skills` and `Remove-RetiredSkills` remove the old `planifest-*` skill folders on the next clean setup run. Setup also removes any leftover old marker files that it finds.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Setup moves the folders itself | One step for the consumer | Setup would hold rename logic for good. A mistake moves user content | Migrations exist for one-off changes |
| Doc-only upgrade steps | No new scripts | Consumers make mistakes by hand. No idempotence | Overrides hold user content |
| Setup continues beside old folders | No forced order | Two packs and two hook sets run at once | Enforcement would split between names |
| Bash helper only | Less to maintain | Windows consumers have no path | The pack supports PowerShell 5.1 and 7 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds migration 0004 and two helpers. Setup gains a leftover-folder check and marker cleanup |

## Consequences

**Positive:**
- A consumer runs one migration and keeps their overrides and workflow.
- A failed run leaves the repo in its starting state, because conflicts stop before any move.

**Negative:**
- Consumers must run the migration before setup. Setup blocks until they do.
- Two helpers on two shells double the test work.

**Risks:**
- A consumer has a custom file inside `planifest-zero/`. The helper does not move it. The migration text tells the consumer to check the folder before removal.

## Related ADRs

- 0000160 ADR-001 - depends-on: the rename map defines the targets
- 0000151 decision "Setup prunes retired hooks by list" - extends: the same prune-by-list approach
- 0000031 ADR-002 - related-to: the last folder rename

## Supersedes

- None

## Superseded By

- None
