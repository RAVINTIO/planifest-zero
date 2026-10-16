---
title: "Requirement: req-003 - atomic-settings-writes"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - atomic-settings-writes

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-003
**Priority:** must-have

## User Story

As a user, I run setup, so that an interrupted write never leaves `.claude/settings.json` truncated.

## Functional Requirements
- Every write of `settings.json` in `setup.sh` writes `settings.json.planifest-tmp` in the same folder, then renames it over the target.
- Every write of `settings.json` in `setup.ps1` does the same, using a same-folder temporary file and a replace or move.
- If the write fails, setup removes the temporary file and leaves the original unchanged. Each site keeps its current warning or stop.
- A run with only current flags writes byte-identical `settings.json` content to 0.4.0.

## Acceptance Criteria
- [ ] In `setup.sh`, a forced failure of the temporary write leaves the original `settings.json` byte-identical and leaves no `settings.json.planifest-tmp` behind.
- [ ] A fresh `setup.sh claude-code` run writes the same `settings.json` bytes as the 0.4.0 script, and a leftover `settings.json.planifest-tmp` is gone after the run.
- [ ] Static checks confirm no `settings.json` write in either script goes straight to the target path.

## Dependencies
- None
