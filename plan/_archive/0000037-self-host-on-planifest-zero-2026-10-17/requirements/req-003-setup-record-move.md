---
title: "Requirement: req-003 - setup-record-move"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-003 - setup-record-move

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-002
**Priority:** must-have

## User Story

As the maintainer, I keep this repo's setup record at `plan/state/claude-code.md`, so that it matches what `planifest-zero/setup.sh` writes.

## Functional Requirements
- Write `plan/state/claude-code.md` in the exact layout that `write_setup_config_override` in `planifest-zero/setup.sh` produces.
- Its JSON block holds `"tool": "claude-code"`, `"flags": []`, and a UTC `writtenAt`. It holds no `backendUrl` key.
- Remove `planifest-overrides/setup-config/claude-code.md` and the empty `planifest-overrides/setup-config/` folder with `git rm`.
- Add the suite `planifest-zero/tests/test-0000037-req-003-setup-record-move.sh`. It checks the tracked record, then runs `setup.sh claude-code` in a temporary copy of the repo.
- The suite runs setup only in its copy and leaves the working tree unchanged.

## Acceptance Criteria
- [ ] `plan/state/claude-code.md` exists, names `claude-code`, has `"flags": []`, and has no `backendUrl` (AC 3).
- [ ] `planifest-overrides/setup-config/` is absent from the tree and from `git ls-files` (AC 4).
- [ ] After `planifest-zero/setup.sh claude-code` runs in a copy of the repo, the copy's `plan/state/claude-code.md` has `"flags": []` and no retired flag (AC 7).
- [ ] That setup run exits 0 and leaves no `planifest-overrides/setup-config/` in the copy.
- [ ] The req-003 suite passes.

## Dependencies
- None. It runs in parallel with req-001, req-002, req-005, and req-009 at P3.
