# Requirement: REQ-004 - the codex CI check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0
**Source:** US-004
**Priority:** must-have

## User Story

As a pack maintainer, I run a CI test that installs for `codex` and checks the files, so that a change cannot break the target.

## Functional Requirements
- A Bash test installs for `codex` in a temporary project and checks `AGENTS.md`, `.agents/skills`, and `.codex/hooks.json`.
- A PowerShell test does the same for `setup.ps1`.
- The CI workflow runs both. The consumer workflow template keeps its current jobs.
- A test installs for `claude-code` and checks that the Claude Code files are unchanged.

## Acceptance Criteria
- [ ] AC-1: the Bash CI test exists
  - Given the test suite
  - When CI runs the Bash suites
  - Then a codex setup test runs and checks the three outputs
- [ ] AC-2: the PowerShell CI test exists
  - Given the Windows CI job
  - When it runs the PowerShell suites
  - Then a codex setup test runs
- [ ] AC-3: Claude Code is unchanged
  - Given a project installed for `claude-code`
  - When a test lists the files
  - Then `CLAUDE.md` and `.claude/settings.json` exist and `AGENTS.md` does not

## Dependencies
- REQ-001, REQ-002, REQ-003
