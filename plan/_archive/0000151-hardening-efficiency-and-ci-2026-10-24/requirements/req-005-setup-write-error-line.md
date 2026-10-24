---
title: "Requirement: req-005 - setup-write-error-line"
summary: "A settings.json write error stops setup with one fixed line that names the relative path, in setup.sh and setup.ps1."
status: "draft"
version: "0.1.0"
---
# Requirement: req-005 - setup-write-error-line

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-005
**Priority:** should-have

## User Story

As a maintainer with a read-only `settings.json`, I see one fixed error line, so that I know what to fix without a stack trace.

## Functional Requirements
- One catch covers both `setup.sh` write sites: the hook install in `install_enforcement_hooks` and the `merge_allowed_tools` write.
  - The catch lives in the shared `PLANIFEST_WRITE_SETTINGS_JS` `writeSettings`.
  - It handles any error from the access check, the temporary write, the chmod, and the rename.
- The catch writes this line to stderr and exits 1:
  `! Error: {relative path} could not be written. Fix its permissions and rerun setup.`
  - The relative path comes from `PLANIFEST_SETTINGS_REL`, for example `.claude/settings.json`.
  - The line holds no absolute path, no error code, and no stack trace.
- The temporary file cleanup that `writeSettings` does today still runs before the exit. The original `settings.json` stays unchanged.
- The telemetry cleanup also calls `writeSettings`. It keeps its single warning on stderr and its non-fatal result, because that caller discards node's stderr and treats a non-zero exit as `error`.
- `setup.ps1` prints the same line text for the same fault and exits 1.
  - `Write-SettingsAtomic` throws `settings.json is read-only: $Path` with an absolute path. Under `$ErrorActionPreference = 'Stop'` that throw reaches the console as a raw PowerShell error.
  - The hook install, `Merge-AllowedTools`, and the other `Write-SettingsAtomic` callers of setup route that fault to the fixed line.
  - The telemetry cleanup in `setup.ps1` keeps its existing `Write-Warning`.
- The existing invalid-JSON line and its exit code do not change.

## Acceptance Criteria
- [ ] (a) A write fault prints the fixed error line and exits 1. All of these hold:
  - With a valid `.claude/settings.json` at mode `444`, `bash planifest-zero/setup.sh claude-code` exits 1. Stderr holds the fixed line with `.claude/settings.json` and no other line from node.
  - In case (a), stderr and stdout hold no absolute path, no `EACCES`, and no `at ` stack frame. The file bytes are unchanged and no `.planifest-tmp` file remains.
  - The same fault in a read-only `.claude/` folder, with no `settings.json` yet, produces the same fixed line and exit 1.
  - A fault at the `merge_allowed_tools` write alone, reached by making the hook install write succeed first, also prints the fixed line once and exits 1.
- [ ] (b) Telemetry cleanup and PowerShell behave as specified. All of these hold:
  - A telemetry cleanup run against a read-only `settings.json` still prints its one warning and does not stop setup, as the existing 0000041 tests assert.
  - The matching PowerShell suite shows `setup.ps1` printing the same line text for a read-only `settings.json` and exiting 1, with no absolute path in the output.
- [ ] (c) Existing tests still pass. All of these hold:
  - The invalid-JSON test cases of `test-0000039-req-001-002-sh-setup-hardening.sh` and `test-0000039-req-001-003-ps1-setup-hardening.ps1` still pass unchanged.

## Dependencies
- Backlog source 0000139 (`plan/current/backlog-sources/0000139-setup-sh-read-only-settings-stack-trace.md`) holds the finding.
- The 0000039 ADR-002 rule, that setup never shows a raw node error, sets the pattern. The 0000041 telemetry warning sets the exception.
- Files in reach:
  - `planifest-zero/setup.sh` (`PLANIFEST_WRITE_SETTINGS_JS` at 27-45, `install_enforcement_hooks` call at about 566, `merge_allowed_tools` write at about 602, telemetry cleanup at 336-381)
  - `planifest-zero/setup.ps1` (`Write-SettingsAtomic` at 240-262, callers at about 505, 518, 551, and 636)
  - `planifest-zero/tests/test-0000151-req-005-setup-write-error-line.sh` (new, models `test-0000039-req-001-002-sh-setup-hardening.sh`)
  - `planifest-zero/tests/test-0000151-req-005-setup-write-error-line.ps1` (new, models `test-0000039-req-001-003-ps1-setup-hardening.ps1`)
  - `planifest-zero/tests/helpers/assert.sh` (existing test helpers)
