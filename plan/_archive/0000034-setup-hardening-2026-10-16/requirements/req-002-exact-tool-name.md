---
title: "Requirement: req-002 - exact-tool-name"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - exact-tool-name

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I pass a tool name to `setup.sh`, so that only an exact match to a valid tool runs, the same as `setup.ps1`.

## Functional Requirements
- Replace the `grep -qw` check in `setup.sh` with an exact string comparison over each entry in `VALID_TOOLS`.
- A non-matching name prints `Unknown tool` and the valid tools, then exits 1, as today.

## Acceptance Criteria
- [ ] `setup.sh claude-code` still runs setup.
- [ ] `setup.sh claude`, `setup.sh code`, `setup.sh '.*'`, and `setup.sh c.aude-code` each exit 1 with `Unknown tool` and change no file.
- [ ] `setup.sh` no longer contains `grep -qw "$TOOL"`.

## Dependencies
- None

## Input Validation

- [ ] Input source: the tool name argument to `setup.sh`
- [ ] Allowed character pattern: exact match to an entry in `VALID_TOOLS`. Anything else is rejected
- [ ] maximum length: not applicable, exact match
- [ ] Failure behaviour: print `Unknown tool` and exit 1
- [ ] Logging policy: the rejected name is echoed in the error, as today
