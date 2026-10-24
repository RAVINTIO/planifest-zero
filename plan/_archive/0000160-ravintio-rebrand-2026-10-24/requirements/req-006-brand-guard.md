---
title: "Requirement: req-006 - brand-guard"
summary: "A guard test fails when the word planifest appears in a tracked path or line outside history and a short allowlist."
status: "active"
version: "0.1.0"
---
# Requirement: req-006 - brand-guard

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-006
**Priority:** must-have

## User Story

As a maintainer, I get a failing test when "planifest" reappears outside history and the allowlist, so that the rebrand does not regress.

## Functional Requirements
- Add the test `ravintio-zero/tests/test-0000160-req-006-brand-guard.sh`. Follow the structure of `test-0000042-req-010-pack-wording-allowlist.sh`.
- Read the tracked files from `git ls-files`.
- Drop these excluded prefixes: `plan/_archive/`, `plan/changelog/`, `ravintio-zero/migrations/_done/`, and `plan/current/`. Ship archives `plan/current/`, so the last prefix goes away then.
- Fail on any tracked path that matches "planifest", case-insensitive, unless an allowlist entry matches.
- Fail on any line that matches "planifest", case-insensitive, unless an allowlist entry matches. Print the file and line number.
- Write each allowlist entry as a path regex and a line regex. Both must match for the line to pass.
- Allowlist only these cases:
  - The 1.x legacy aliases: the `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS` fallback, and the `planifest-em-dash-allow` sentinel.
  - The migration `0004-ravintio-rename.md`, its helpers, and their tests.
  - Setup's detection of leftover `planifest-zero/` and `planifest-overrides/` folders, and its cleanup of old markers.
  - This test and its regression copy, which must name the word to match it.
- Add a second case. Plant "Planifest" in a scratch copy of `README.md` and expect the check to flag it with its file and line number.
- Supersede the 0000042 allowlist approach for the brand word. The "framework" allowlist test stays.

## Acceptance Criteria
- [ ] The guard test passes on the shipped tree, with every remaining match covered by an allowlist entry.
- [ ] The planted-line case fails the check and reports the scratch `README.md` file and line number.
- [ ] A tracked path containing "planifest" outside the excluded prefixes and allowlist fails the check.

## Dependencies
- REQ-001 to REQ-004 remove the brand from paths and prose before this test can pass.
- REQ-005 supplies the migration files that the allowlist covers.
- Existing pattern: `test-0000042-req-010-pack-wording-allowlist.sh`.
