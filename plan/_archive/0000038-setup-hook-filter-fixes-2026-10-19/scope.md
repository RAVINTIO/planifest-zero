---
title: "Scope - setup-hook-filter-fixes"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.5.1"
---
# Scope - setup-hook-filter-fixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Wave:** 1
**Version:** 0.5.1

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- req-001-per-command-filter (US-001, backlog 0000112): `setup.sh` and `setup.ps1` filter the `PreToolUse` and `UserPromptSubmit` events one command at a time.
- req-001-per-command-filter: an entry keeps its user commands in their order. If no command remains, setup drops the entry. Setup then appends the fresh Planifest entries once.
- req-002-userpromptsubmit-parity (US-002, backlog 0000111): `setup.sh` matches `UserPromptSubmit` commands with the path-boundary, case-sensitive rule that `setup.ps1` already uses.
- Planted-entry cases in the `.sh` and `.ps1` suites. They cover shared entries, Planifest-only entries, a `check-design` substring path, a run-twice case, and parity on the same fixtures.
- A patch release, version 0.5.1, with no change to the installed hook set.

## Out of Scope

- The telemetry cleanup. It already filters one command at a time.
- Hook events other than `PreToolUse` and `UserPromptSubmit`.
- Changes to the atomic settings write (0000034 ADR-002).
- Changes to the path-boundary, case-sensitive match itself (0000035 S-004).

## Deferred

- A user script with a Planifest basename in another folder, such as `/home/u/tools/gate-write.mjs`. Setup still removes it. A fix needs a narrower match on the hook folder, and old setups wrote several folder shapes. Nothing is blocked.
