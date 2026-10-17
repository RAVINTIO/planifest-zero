---
title: "Requirement: req-002 - manifest-both-ways"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - manifest-both-ways

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Source:** US-002, backlog 0000084
**Priority:** should-have

## User Story

As a maintainer, I promote a regression suite, so that a suite on disk with no manifest entry fails the run.

## Functional Requirements
- Section 7 of `test-regression-pack.sh` treats `test-*.ps1` in `tests/regression/` the same as `test-*.sh`. Each needs a manifest entry.
- The existing check, that every entry names a file on disk, stays.

## Acceptance Criteria
- [ ] The unlisted-suite filter in Section 7 matches `.sh` and `.ps1` files.
- [ ] `test-regression-pack.sh` passes on the real `tests/regression/`.

## Dependencies
- None
