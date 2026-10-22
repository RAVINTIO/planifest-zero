---
title: "Scope - setup-cleanup-and-park-hardening"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.8.0"
---
# Scope - setup-cleanup-and-park-hardening

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Wave:** 1
**Version:** 0.8.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- req-001-setup-sh-cleanup-skip and req-002-setup-ps1-cleanup-skip (US-001, US-002, backlog 0000127 and 0000128): the telemetry cleanup in both setup scripts skips a `settings.json` that fails the shape check. It prints nothing and writes nothing. The hook install step then reports the fault.
- req-003-non-array-warning-no-value (US-003, backlog 0000130): both setup scripts name the event and the file in the non-array warning. The warning omits the old value.
- req-004-park-local-failure-cleanup (US-004, backlog 0000129): `park.mjs` unstages and removes the written entry file when a local add or commit fails. It then returns to the feature branch.

## Out of Scope

- Retiring the legacy telemetry cleanup (0000095).
- A backup file for the old non-array value.
- Park's push and `gh` failure paths.

## Deferred

- Nothing deferred.
