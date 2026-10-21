---
title: "Requirement: req-002 - setup-ps1-shape-check"
summary: "setup.ps1 prints the same fixed error and exits 1 when settings.json is valid JSON that PowerShell cannot read as a settings object."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - setup-ps1-shape-check

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Source:** US-002 (backlog 0000120)
**Priority:** must-have

## User Story

As a person running `setup.ps1`, I get the same fixed error line when `settings.json` is valid JSON that PowerShell cannot read as a settings object, so that the message names the real fault instead of calling valid JSON invalid.

## Functional Requirements
- In `Merge-EnforcementHookSettings`, the check runs after `Test-JsonText` and `ConvertFrom-Json` succeed and before the script reads `hooks`. It runs before any write.
- The check rejects the file when any condition holds:
  - The top-level value is not a `PSCustomObject`. Arrays, `null`, strings, numbers, and booleans all fail.
  - `hooks` is present and is not a `PSCustomObject`. A `hooks` value of `null` counts as absent, as today, and passes.
  - The text has two keys that differ only by case, such as `{"a":1,"A":2}`. `ConvertFrom-Json` throws on these in PowerShell 5.1 and 7.
  - The text nests deeper than 1024 levels. req-003 defines how `Test-JsonText` reports this.
- On rejection, the script prints exactly one line to stderr: `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`
  - `{path}` is `$SettingsRel`, as the invalid-JSON line prints it today.
  - The line never includes the file's contents, a parser message, or a stack trace.
- On rejection, the script leaves `settings.json` byte-identical and exits 1.
- Text that is not strict JSON keeps the existing line from 0000039 ADR-002: `! Error: {path} is not valid JSON. Fix it and rerun setup.`
- A `ConvertFrom-Json` failure on text that `Test-JsonText` accepts is a case-duplicate or depth fault. It prints the shape line and never the invalid-JSON line.
- The message text is identical to the one in req-001. A parity test asserts the exact line for both scripts.

## Acceptance Criteria
- [ ] (a) Each of `["x"]`, `null`, `"text"`, `42`, `true`, `{"hooks":"text"}`, `{"hooks":[]}`, `{"hooks":5}`, and `{"a":1,"A":2}` makes `setup.ps1` print `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` to stderr and exit 1. The file stays byte-identical.
- [ ] (b) A value planted in a rejected file, such as `["PLANTED-VALUE"]`, appears in neither stdout nor stderr.
- [ ] (c) `{"hooks":null}` exits 0 with the hooks wired. `{"a":1,` still prints the existing invalid-JSON line and exits 1.

## Dependencies
- 0000039 ADR-002 (invalid-JSON message) and 0000037 ADR-003 (non-array hooks events) stand.
- Setup never logs `settings.json` contents (0000033 req-004).
- req-001 implements the same check in `setup.sh`. The parity test depends on both.
- req-003 changes `Test-JsonText`, which this check follows.
- Assumption from the design: PowerShell 5.1 and 7 both throw on case-duplicate keys. If PowerShell 7 does not, test (c) needs a version guard.
- PowerShell tests skip locally when `pwsh` is missing. CI runs them.
