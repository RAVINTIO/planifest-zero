---
title: "Scope - setup-hardening-release-sizing"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.6.0"
---
# Scope - setup-hardening-release-sizing

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Wave:** 1
**Version:** 0.6.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- req-001 invalid JSON (US-001, backlog 0000113): the invalid JSON handling in the hook install step of `setup.sh` and `setup.ps1`. Each script prints one fixed line that names the file, leaves the file unchanged, and exits 1.
- req-002 single-object `hooks` (US-002, backlog 0000114): both scripts treat a single-object `hooks` value as a one-item array, then apply the 0000038 per-command filter.
- req-003 PowerShell JSON depth (US-003, backlog 0000115): `setup.ps1` writes `settings.json` with `-Depth 100`.
- req-004 release size (US-004, backlog 0000109): the `releaseSize` setting, the size classes, and the budgets in the orchestrator skill.
- req-004 release size: the fixed 3-story rule is replaced in the orchestrator skill and in both feature brief templates.
- Cases in the `.sh` and `.ps1` suites, and a suite for the sizing text.
- A minor release, version 0.6.0, for the new optional `product.yml` setting.

## Out of Scope

- The telemetry cleanup's error handling. It already warns and continues.
- Hook events other than `PreToolUse` and `UserPromptSubmit`.
- Tooling that counts files automatically. Discovery estimates the size class.

## Deferred

- Nothing deferred.
