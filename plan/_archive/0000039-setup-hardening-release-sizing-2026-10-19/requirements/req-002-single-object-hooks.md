---
title: "Requirement: req-002 - single-object-hooks"
summary: "Setup treats a single-object hooks value as a one-item array, then applies the per-command filter."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - single-object-hooks

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Source:** US-002 (backlog 0000114)
**Priority:** must-have

## User Story

As a user whose hook entry holds one `hooks` object, I rerun setup, so that a stale Planifest command goes and each hook runs once.

## Functional Requirements
- If a `PreToolUse` or `UserPromptSubmit` entry has a `hooks` value that is one object, `setup.sh` and `setup.ps1` treat it as a one-item array.
- The 0000038 per-command filter then applies to that item.
- If the command is a Planifest command, setup removes the entry. The fresh Planifest entries then appear once.
- If the command is a user command, setup keeps the entry as it was.
- Both scripts give the same result on the same input.
- A `hooks` value that is neither an array nor an object, and an empty array, stay as they were.
- This changes the 0000038 ADR-002 rule that a non-array `hooks` value stays as it was. The rule now covers only non-array, non-object values.
- In `setup.ps1`, build the array with `@()` so Windows PowerShell 5.1 does not unwrap a one-item array (risk R-001).

## Acceptance Criteria
- [ ] (a) A single-object `hooks` value that runs a Planifest module is gone after either script runs, and the fresh entries appear once.
- [ ] (b) A single-object `hooks` value that runs only a user command stays after either script runs.

## Dependencies
- req-001 of 0000038 defines the per-command filter that this requirement extends.
- 0000035 S-004 keeps the case-sensitive, path-boundary module match.
