---
title: "Requirement: req-001 - stray-file-check"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - stray-file-check

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Source:** US-001, backlog 0000084
**Priority:** must-have

## User Story

As a maintainer, I add a test file that misses the naming rule, so that the run fails and names the file.

## Functional Requirements
- Before it runs any suite, `run-tests.sh` lists every file under `tests/`, including `regression/` and `helpers/`.
- It ignores suites and the known non-suites the design lists. The allowlist lives in one array with a comment.
- It prints `Undiscovered file: <path relative to tests/>` for each other file, still runs the suites, then exits 1.

## Acceptance Criteria
- [ ] A run over a copy of `tests/` with a planted `tests/my-check.sh` exits 1 and names `my-check.sh`.
- [ ] A planted `tests/regression/notes.txt` is named the same way.
- [ ] A run over the real `tests/` prints no `Undiscovered file` line.

## Dependencies
- None
