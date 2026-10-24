---
title: "Requirement: REQ-002 - runtime-names"
summary: "Hooks, setup scripts, and CI detect and write ravintio names instead of planifest names."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - runtime-names

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-002
**Priority:** must-have

## User Story

As a consumer, I get hooks, setup, and scripts that detect and write `ravintio` names, so that enforcement keeps working after the rename.

## Functional Requirements
- `auto-trigger-orchestrator.mjs` detects `ravintio-zero/` as the pack folder.
- `self-description-check.mjs` matches `ravintio-zero/` paths.
- `em-dash-guard.mjs` uses the `ravintio-zero/` path prefixes. Its scope is otherwise unchanged, so it still does not cover the overrides folder.
- `em-dash-guard.mjs` honours the sentinel `ravintio-em-dash-allow`. It also accepts the old `planifest-em-dash-allow` in 1.x.
- `gate-write.mjs` reads and writes the `.ravintio-session` marker.
- `setup.sh` and `setup.ps1` write `.ravintio-setup-flags` and `.ravintio-manifest`, and use the `.ravintio-tmp` suffix.
- `setup.sh` and `setup.ps1` write `ravintio-overrides:instructions` markers and set `core.hooksPath` to `ravintio-zero/hooks`.
- `setup.sh` and `setup.ps1` copy the workflow as `ravintio.yml` and write the token-reduction marker under the new name.
- Setup removes old `.planifest-*` marker files.
- If setup finds a leftover `planifest-zero/` or `planifest-overrides/` folder, it stops and tells the consumer to run the migration first.
- The CI workflow paths and names use `ravintio`.
- Hook messages that name skills use the `ravintio-*` skill names.

## Acceptance Criteria
- [ ] Each hook and script named above detects and writes only the `ravintio` names, and `em-dash-guard.mjs` accepts both sentinels.
- [ ] Setup on Bash and PowerShell writes the `.ravintio-*` markers, removes any old `.planifest-*` markers, and sets `core.hooksPath` to `ravintio-zero/hooks`.
- [ ] Setup on both shells exits non-zero with a migration message when a `planifest-zero/` or `planifest-overrides/` folder exists.

## Dependencies
- REQ-001 provides the renamed paths.
- REQ-005 provides the migration that setup points consumers to.
