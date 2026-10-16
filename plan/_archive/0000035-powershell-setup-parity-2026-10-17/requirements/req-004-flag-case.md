---
title: "Requirement: req-004 - flag-case"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - flag-case

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Source:** US-004, backlog 0000105
**Priority:** should-have

## User Story

As a maintainer, I pass a flag in the wrong case to `setup.ps1`, so that it fails as `setup.sh` does.

## Functional Requirements
- The argument `switch` in `setup.ps1` is `switch -CaseSensitive`.
- `--Strict-Orchestrator` falls through to the unknown-flag branch and exits 1.

## Acceptance Criteria
- [ ] The argument loop uses `switch -CaseSensitive`.
- [ ] The `--strict-orchestrator` case label is lower case.

## Dependencies
- None
