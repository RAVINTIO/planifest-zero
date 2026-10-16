---
title: "Requirement: req-001 - retired-flags"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - retired-flags

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-001
**Priority:** must-have

## User Story

As a user refreshing an install made before 0000033, I run setup with my recorded flags, so that setup warns about each retired flag, skips it, and completes.

## Functional Requirements
- Both `setup.sh` and `setup.ps1` recognise exactly four retired flags: `--structured-telemetry-mcp`, `--backend-url`, `--context-mode-mcp`, and `--include-full-skill-library`.
- For each retired flag, setup prints one warning that names the flag and says it is retired and ignored, then continues.
- After `--backend-url`, setup also skips the next argument if it doesn't start with `--`. Setup never runs, echoes, or writes that value.
- Any other argument starting with `-` still prints `Unknown flag` and exits 1.
- The usage text doesn't list retired flags.

## Acceptance Criteria
- [ ] `setup.sh claude-code --structured-telemetry-mcp --backend-url http://x --context-mode-mcp --include-full-skill-library` exits 0, prints four retired-flag warnings, never prints `http://x`, and writes a marker whose `flags` is `[]`.
- [ ] `setup.sh claude-code --backend-url --strict-orchestrator` and `setup.sh claude-code --backend-url` both exit 0, and the first writes `plan/.orchestrator-strict`.
- [ ] `setup.sh claude-code --bogus` exits 1 with `Unknown flag`, and static checks confirm `setup.ps1` holds the same four names and the `--` value rule.

## Dependencies
- None

## Input Validation

- [ ] Input source: command-line arguments to `setup.sh` and `setup.ps1`
- [ ] Allowed character pattern: retired flags match by exact string only. The `--backend-url` value isn't validated, because setup discards it
- [ ] maximum length: not applicable, the value is discarded
- [ ] Failure behaviour: a retired flag warns and continues. Any other `-` argument exits 1
- [ ] Logging policy: raw `--backend-url` value never logged
