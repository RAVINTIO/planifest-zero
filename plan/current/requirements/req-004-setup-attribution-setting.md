---
title: "Requirement: REQ-004 - setup-attribution-setting"
summary: "Setup turns off the host's commit and PR attribution lines when the setting is absent."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - setup-attribution-setting

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Source:** US-002 (backlog 0000166)
**Priority:** must-have

## User Story

As a maintainer, I get setup to turn off the host's attribution lines, so that the agent never writes them in the first place.

## Functional Requirements
- Today `merge_allowed_tools` in `ravintio-zero/setup.sh` and `Merge-AllowedTools` in `ravintio-zero/setup.ps1` write only `allowedTools`. Neither sets `attribution`.
- For the claude-code tool, `setup.sh` sets `"attribution": {"commit": "", "pr": ""}` in `.claude/settings.json` when the `attribution` key is absent.
- `setup.ps1` does the same and produces the same JSON value.
- If the `attribution` key is present with any value, setup leaves it untouched.
- Setup writes the file through the existing atomic settings writer, as `merge_allowed_tools` does today.
- A rerun of setup changes nothing once the key exists.

## Acceptance Criteria
- [ ] After `setup.sh` and after `setup.ps1` on a claude-code project with no `attribution` key, `.claude/settings.json` holds `{"commit": "", "pr": ""}` under `attribution`.
- [ ] A settings file that already holds an `attribution` key, with any value, is byte-identical after setup in both shells.
- [ ] A second setup run leaves `.claude/settings.json` byte-identical in both shells.

## Dependencies
- None. The existing atomic settings writer in both shells is reused.
