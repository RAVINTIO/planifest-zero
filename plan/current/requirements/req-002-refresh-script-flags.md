---
title: "Requirement: req-002 - refresh-script-flags"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-002 - refresh-script-flags

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-003
**Priority:** must-have

## User Story

As the maintainer, I run `refresh-planifest-zero-dir.ps1`, so that it reinstalls with no flag that setup has retired.

## Functional Requirements
- Change the last line of `refresh-planifest-zero-dir.ps1` to `.\planifest-zero\setup.ps1 claude-code`, with no `--structured-telemetry-mcp`.
- Keep the `$PSScriptRoot` path and the three `Remove-Item` lines, so rename suite case (d) still passes.
- Add the suite `planifest-zero/tests/test-0000037-req-002-refresh-script-flags.sh`. If the script isn't next to `planifest-zero/`, it skips.

## Acceptance Criteria
- [ ] `refresh-planifest-zero-dir.ps1` contains none of the retired flags that `setup.sh` warns about: `--structured-telemetry-mcp`, `--context-mode-mcp`, `--include-full-skill-library`, and `--backend-url` (AC 6).
- [ ] The script still calls `planifest-zero\setup.ps1 claude-code`.
- [ ] The req-002 suite passes, and rename suite case (d) still passes.

## Dependencies
- None. It runs in parallel with req-001, req-003, req-005, and req-009 at P3.
