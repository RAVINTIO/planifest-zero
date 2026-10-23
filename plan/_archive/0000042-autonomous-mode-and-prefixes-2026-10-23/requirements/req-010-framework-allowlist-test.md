---
title: "Requirement: req-010 - framework-allowlist-test"
summary: "A new test greps tracked files for the word framework and fails on any line outside an allowlist of generic uses."
status: "active"
version: "0.1.0"
---
# Requirement: req-010 - framework-allowlist-test

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer of Planifest Zero, I want a test that fails when the old wording returns, so that no file calls Planifest Zero a framework again.

## Functional Requirements
- A new test in `planifest-zero/tests/` reads `git ls-files` and searches for "framework", case-insensitive.
- The test drops paths that start with these prefixes:
  - `plan/_archive/`, because it is history.
  - `plan/changelog/`, because it is history.
  - `planifest-zero/migrations/_done/`, because those files are past records.
  - `plan/current/`, because the files quote the old words to describe the rename.
- The `plan/current/` exclusion lasts for the duration of the feature. `planifest-ship` moves those files into the archive. ADR-004 records this exemption.
- A matching line passes if it matches an allowlist entry. Any other line fails the test, and the test prints the file and line number.
- The allowlist lives in the test file. Each entry carries a comment that names the generic use it covers.
- The allowlist entries cover:
  - Lines in the 21 `test-frameworks.md` standards, and links to them.
  - The two stack evaluation standards and the web framework tables in the `prefer-avoid.md` files.
  - "meta-framework", "test framework", "testing framework", and "language or framework in use".
  - The `stack.framework`, `stack.frontend`, and `stack.testing` lines in `component-guide.md` and the `framework:` line in `component.template.yml`.
  - "Planifest Framework" and `planifest/planifest-framework`.
  - The `sourceFeature` lines in `regression-manifest.json`.
  - The 0000030 `framework-cut-down` lines in `docs/decisions-index.md`.
  - The lines of the allowlist test itself, which must name the word to match it.
- A second case in the test adds the line "Planifest Zero is a framework" to a scratch copy of `README.md` and expects a failure.

## Files in reach

- The new test file in `planifest-zero/tests/`.
- `planifest-zero/tests/regression/regression-manifest.json`, which lists the new test.
- Every tracked file outside the excluded prefixes, which the test reads and does not change.

## Acceptance Criteria
- [ ] (a) The allowlist test passes. It reports zero lines with "framework" in tracked files outside `plan/_archive/`, `plan/changelog/`, `planifest-zero/migrations/_done/`, and `plan/current/`, other than allowlisted generic uses.
- [ ] (b) The allowlist test fails when a deliberate line such as "Planifest Zero is a framework" is added to a scratch copy of `README.md`.
- [ ] (c) `git diff --stat` shows no change under `plan/_archive/` or `plan/changelog/`.

## Dependencies
- REQ-008 (prose) and REQ-009 (identifiers) land first, so the test passes when it first runs.
- Run modes (REQ-001 to REQ-003) and phase numbers (REQ-004 to REQ-006) land before this requirement. Product name (REQ-007) lands before it too.
- ADR-004 defines the allowlist entries and the exclusions.
