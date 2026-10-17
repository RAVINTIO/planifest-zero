---
title: "Requirement: req-007 - sh-filter-any-matcher"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-007 - sh-filter-any-matcher

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-005, backlog 0000106
**Priority:** must-have

## User Story

As a user who ran an older `setup.ps1`, I run `setup.sh` and get `gate-write` wired once, so that it doesn't run twice on each write.

## Functional Requirements
- The `PreToolUse` merge in `planifest-zero/setup.sh` removes every entry with a `gate-write`, `ratchet-check`, or `em-dash-guard` command, on any matcher. Today it removes only entries whose matcher is `Write` or `Edit`.
- The filter matches the module name the way `setup.ps1` does. It is case-sensitive and matches only `<module>.mjs` at a path boundary (0000035 S-004).
- An entry whose commands name no Planifest module stays, whatever its matcher.
- A new suite, `planifest-zero/tests/test-0000037-req-007-sh-filter-any-matcher.sh`, plants a `settings.json` with a `Write|Edit` `gate-write` entry and a user hook, then runs `setup.sh claude-code`.

## Acceptance Criteria
- [ ] After the run, `gate-write` appears once for `Write` and once for `Edit`, and no `Write|Edit` entry remains (AC 12).
- [ ] The planted user hook is still present.
- [ ] A second run leaves `settings.json` unchanged.
- [ ] `test-0000035-req-001-hook-parity.sh` still passes.

## Dependencies
- req-008 edits the same `setup.sh` merge block. One P3 subagent runs req-007 first, then req-008.
