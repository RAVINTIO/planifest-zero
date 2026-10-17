---
title: "Requirement: req-008 - non-array-hook-events"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-008 - non-array-hook-events

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-006, backlog 0000107
**Priority:** must-have

## User Story

As a user with a hand-edited `settings.json`, I run either setup script on a non-array hook event and get a warning and working hooks, so that setup doesn't fail or keep a broken entry.

## Functional Requirements
- Both `planifest-zero/setup.sh` and `planifest-zero/setup.ps1` apply one rule to `hooks.PreToolUse` and `hooks.UserPromptSubmit`. If the value is present and isn't an array, the script warns and replaces it with the Planifest entries.
- The warning names the event and `.claude/settings.json`, and says setup replaced the value. Both scripts print the same text.
- A present value that isn't an array warns, including `""`, `0`, and `false`.
- An absent or `null` value keeps today's behaviour: the script wires the Planifest entries with no warning.
- An array value keeps today's merge, with req-007's filter in `setup.sh`.
- `setup.sh` no longer throws on an object or string value. `setup.ps1` no longer wraps the value with `@(...)` and keeps it as an entry.
- The legacy telemetry cleanup keeps its rule from 0000035 req-002, which leaves a non-array value as it was.
- Two new suites prove the rule:
  - `planifest-zero/tests/test-0000037-req-008-non-array-hook-events.sh` runs `setup.sh`.
  - `planifest-zero/tests/test-0000037-req-008-non-array-hook-events.ps1` runs `setup.ps1` through `helpers/setup-workspace.ps1`.
- Each suite plants an object value and a string value for each event.

## Acceptance Criteria
- [ ] `setup.sh` exits 0, prints the warning, and wires the Planifest entries for each planted value (AC 13).
- [ ] `setup.ps1` does the same on Windows PowerShell 5.1 and PowerShell 7 (AC 14). The `windows-powershell` CI job runs both hosts.
- [ ] After either script runs, the event value is an array that holds only the Planifest entries.
- [ ] `test-0000035-req-001-hook-parity.sh` and `test-0000036-req-004-setup-ps1-install.ps1` still pass.

## Dependencies
- req-007 edits the same `setup.sh` merge block. One P3 subagent runs req-007 first, then req-008.
