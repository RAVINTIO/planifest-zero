---
title: "Requirement: REQ-002 - fail on retired flags"
summary: "Setup exits 1 on any retired flag during argument parsing and names the flag."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - fail on retired flags

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I run setup with a retired flag and the run exits 1 with an error that names the flag, so that I remove a flag that does nothing.

## Functional Requirements
- These flags are retired: `--structured-telemetry-mcp`, `--context-mode-mcp`, `--include-full-skill-library`, and `--backend-url` in both the `--backend-url x` and `--backend-url=x` forms.
- A retired flag exits 1 during argument parsing, before any other processing, in both scripts.
- The error names the flag, says that it was removed and does nothing, and tells the user to remove it from the command.
- The error prints the flag name only. A `--backend-url` value never appears in the output.
- The six existing tests that assert the warning assert the error instead.
- The component manifest and the docs stop describing the warning.

## Acceptance Criteria
- [ ] AC-1: each retired flag exits 1 with a named error
  - Given a fresh temp git repo that holds the pack
  - When setup runs with `claude-code` and one retired flag
  - Then the exit code is 1 and the error names that flag, says it does nothing, and says to remove it
- [ ] AC-2: a rejected run leaves the repo unchanged
  - Given the same fresh temp repo
  - When setup rejects a retired flag
  - Then the tree matches its snapshot and `core.hooksPath` is unset
- [ ] AC-3: the backend URL value stays out of the output
  - Given setup runs with `--backend-url` followed by a distinctive value, in both forms
  - When setup rejects the flag
  - Then neither stdout nor stderr contains that value

## Dependencies
- REQ-001, which moves the check point that this requirement shares
