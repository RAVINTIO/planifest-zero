# Requirement: REQ-004 - setup wires the Stop hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I get a warning when a reply in an active run lacks a valid prefix, and the misses are logged, so that I can measure how often the rule fails.

## Functional Requirements
- `setup.sh` and `setup.ps1` copy `check-reply-prefix.mjs` to the hooks folder and add one `Stop` entry that runs it.
- A rerun of either script leaves one `Stop` entry for the hook, and keeps any `Stop` entry the user added.
- The two scripts write the same entry, and the hook-parity suite checks the match.
- `ravintio-zero/component.yml`, the boot template's Hook Enforcement list, and the docs that list the hooks name the new hook.

## Acceptance Criteria
- [ ] AC-1: setup installs the hook
  - Given a fresh project
  - When setup runs
  - Then the hook file exists in the hooks folder and `settings.json` holds one `Stop` entry for it
- [ ] AC-2: setup is idempotent
  - Given a project with a user `Stop` entry
  - When setup runs twice
  - Then `settings.json` holds the user entry and exactly one entry for the hook
- [ ] AC-3: both scripts agree
  - Given `setup.sh` and `setup.ps1`
  - When the parity suite runs
  - Then both wire the same `Stop` entry and the docs name the hook

## Dependencies
- REQ-003
