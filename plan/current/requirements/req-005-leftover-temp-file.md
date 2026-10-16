---
title: "Requirement: req-005 - leftover-temp-file"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - leftover-temp-file

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Source:** US-005, backlog 0000104
**Priority:** should-have

## User Story

As a user, I re-run setup after a hard stop, so that no `settings.json.planifest-tmp` stays behind.

## Functional Requirements
- Early in each run, before any `settings.json` write, both scripts remove `.claude/settings.json.planifest-tmp` in the project if it exists as a file or a symlink.
- The removal never follows a symlink and never removes a folder.
- `setup.sh` removes it whether or not `node` is on the `PATH`.
- The removal prints nothing.

## Acceptance Criteria
- [ ] A `setup.sh` run with a planted leftover file ends with no leftover.
- [ ] A `setup.sh` run with `node` hidden from the `PATH` still removes the leftover.
- [ ] A planted symlink at the temporary path is removed and its target survives.
- [ ] `setup.ps1` holds the same removal before its first settings write (static check).

## Dependencies
- None
