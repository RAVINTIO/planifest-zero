---
title: "Requirement: req-001 - invalid-json"
summary: "Setup prints one fixed error for an invalid settings.json, never leaks its content, and leaves the file unchanged."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - invalid-json

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Source:** US-001 (backlog 0000113)
**Priority:** must-have

## User Story

As a user with a malformed `settings.json`, I run setup, so that I get one clear error and none of the file's content reaches my logs.

## Functional Requirements
- In the hook install step, `setup.sh` and `setup.ps1` catch the parse error for `settings.json`.
- On a parse error, each script prints exactly one line: `! Error: {path} is not valid JSON. Fix it and rerun setup.`
  - `{path}` is the settings file path, as the scripts print it today.
  - The line never includes the file's contents, a parser message, or a stack trace.
- On a parse error, each script leaves `settings.json` byte-identical and exits 1.
- The `JSON.parse` call in the `setup.sh` allowedTools step reads the same file.
  - The hook install step runs first, so an invalid file stops setup before this step.
  - If this step is reached on its own, it prints the same fixed line and exits 1.
- The `ConvertFrom-Json` call in the `setup.ps1` allowedTools step already catches the error and prints a fixed warning. It stays as it is.
- The `ConvertFrom-Json` call in the `setup.ps1` telemetry cleanup keeps its warn-and-continue behaviour. This requirement does not change it.
- The `setup.sh` telemetry cleanup also keeps its warn-and-continue behaviour.
- `setup.ps1` checks the text against strict JSON before `ConvertFrom-Json` runs. PowerShell 7 accepts trailing commas and comments, and `JSON.parse` rejects them. The check makes both scripts reject the same files. This detail was added during implement.

## Acceptance Criteria
- [ ] (a) With invalid JSON in `settings.json`, running either script prints the one fixed line naming the file, exits 1, and leaves the file byte-identical.
- [ ] (b) A value planted in an invalid `settings.json` appears in neither stdout nor stderr of either script.

## Dependencies
- Setup never logs `settings.json` contents (0000033 req-004).
- Settings writes stay atomic (0000034 ADR-002). This requirement adds no write on the error path.
- req-002 and req-003 change the same install step in both scripts. Build them in order.
