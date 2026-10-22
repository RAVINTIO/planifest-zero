---
title: "Requirement: req-003 - non-array-warning-no-value"
summary: "Both setup scripts warn about a non-array hooks event with the event name and the file, and never print the old value."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - non-array-warning-no-value

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Source:** US-003 (backlog 0000130, also 0000038 F-006, 0000039 F-001, 0000040 F-009)
**Priority:** must-have

## User Story

As a person running either setup script, I get a warning that names the event and the file but not the old value, so that a secret in a hook command never reaches the terminal or a log.

## Functional Requirements
- Both scripts print this warning to stderr when `hooks.PreToolUse` or `hooks.UserPromptSubmit` is present and is not an array: `  ! Warning: hooks.{event} in {file} is not an array. Setup replaced it with the Planifest entries.`
  - `{event}` is `PreToolUse` or `UserPromptSubmit`.
  - `{file}` is the settings file path relative to the project root, as the warning prints it today.
  - The text is identical in `setup.sh` and `setup.ps1`, including the two leading spaces.
- The warning no longer includes `Old value:` or any serialised form of the old value.
  - In `setup.sh`, the warning in the inline node script in `install_enforcement_hooks` drops the `JSON.stringify` of the value.
  - In `setup.ps1`, the warning in `Merge-EnforcementHookSettings` drops the `ConvertTo-Json` call and the `$oldValue` variable.
- Setup does not save the old value anywhere. A backup file is out of scope.
- Behaviour is otherwise unchanged from 0000037 ADR-003.
  - Setup replaces the non-array value with the Planifest entries.
  - An absent or `null` value gets the entries and no warning.
  - An array value gets no warning.
- The existing tests that assert today's text change to assert the new line. They are:
  - `planifest-zero/tests/test-0000037-req-008-non-array-hook-events.sh`
  - `planifest-zero/tests/regression/test-0000037-req-008-non-array-hook-events.sh`
  - `planifest-zero/tests/test-0000037-req-008-non-array-hook-events.ps1`
  - `planifest-zero/tests/test-0000039-req-001-003-ps1-setup-hardening.ps1`, which asserts `Old value:` for a 12-level value at line 221. That assertion now checks that the value is absent.
- A parity test asserts the exact new line for both scripts.
- PowerShell tests run only in CI. They skip locally when `pwsh` is missing.

## Acceptance Criteria
- [ ] (a) Given a non-array `hooks.PreToolUse` or `hooks.UserPromptSubmit` that holds a secret string, such as `"PLANTED-SECRET"`, each script prints exactly `  ! Warning: hooks.{event} in .claude/settings.json is not an array. Setup replaced it with the Planifest entries.` The secret appears in neither stdout nor stderr.
- [ ] (b) After the run, the event holds the Planifest entries and no other value. An absent or `null` event prints no warning.
- [ ] (c) The test suite asserts that the warning text is identical in `setup.sh` and `setup.ps1`, and no test asserts `Old value:` as present in setup output.

## Dependencies
- 0000037 ADR-003 stands: a non-array value is replaced with the Planifest entries, and an absent or `null` value gets no warning.
- Setup never prints `settings.json` content (0000033 req-004).
- `setup.sh` and `setup.ps1` carry the same text. A change to one needs the same change in the other.
