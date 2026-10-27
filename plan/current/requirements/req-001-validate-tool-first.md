---
title: "Requirement: REQ-001 - validate the tool first"
summary: "Setup rejects a missing or unknown tool straight after argument parsing, before any change to the repo."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - validate the tool first

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I run setup with a missing or unknown tool and the run exits 1 with no change to the repo, so that a rejected run never enables hooks or adds workflow files.

## Functional Requirements
- `setup.sh` and `setup.ps1` check the tool straight after argument parsing. The check runs before the old-folder check and before `initialize_repo` (`Initialize-RavintioRepo`).
- A missing or unknown tool prints the existing `Unknown tool` text and usage, then exits 1. The text and the exit code stay as they are.
- A rejected run creates, changes, and removes no file. It leaves `core.hooksPath` unset.

## Acceptance Criteria
- [ ] AC-1: unknown tool leaves the repo unchanged
  - Given a fresh temp git repo that holds the pack
  - When setup runs with the tool `codex`
  - Then the exit code is 1, the tree matches its snapshot from before the run, and `core.hooksPath` is unset
- [ ] AC-2: missing tool leaves the repo unchanged
  - Given a fresh temp git repo that holds the pack
  - When setup runs with no tool
  - Then the exit code is 1, the tree matches its snapshot, and `core.hooksPath` is unset
- [ ] AC-3: valid tool still installs
  - Given a fresh temp git repo that holds the pack
  - When setup runs with the tool `claude-code`
  - Then the exit code is 0 and `core.hooksPath` is `ravintio-zero/hooks`

## Dependencies
- None
