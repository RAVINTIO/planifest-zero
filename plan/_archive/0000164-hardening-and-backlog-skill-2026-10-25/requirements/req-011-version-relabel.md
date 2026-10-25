---
title: "Requirement: REQ-011 - version-relabel"
summary: "The rename release reads as 0.12.0, this release as 0.13.0, and live files drop the 1.x and 2.0.0 promises."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-011 - version-relabel

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Source:** US-006
**Priority:** must-have

## User Story

As the maintainer, I see the rename release as 0.12.0 and this one as 0.13.0, so that the version line matches the minor bumps I asked for.

## Functional Requirements
- Live files outside `plan/_archive/` and `plan/changelog/` stop promising a 1.x line. Each "remove at 2.0.0" becomes "remove at 1.0.0", and each "in 1.x" becomes "in 0.x". This covers comments in `ravintio-zero/setup.sh`, `ravintio-zero/setup.ps1`, `ravintio-zero/hooks/enforcement/em-dash-guard.mjs`, and `ravintio-zero/scripts/roadmap-run.mjs`, test labels, `docs/decisions-index.md`, and `docs/dependency-graph.md`.
- `docs/decisions-index.md` notes that 0000164 ADR-005 supersedes the version decision in 0000160 ADR-001 and moves the fallback removal in 0000160 ADR-002 to 1.0.0.
- `ravintio-zero/tests/test-0000160-req-004-brand-prose.sh` asserts a version of 0.12.0 or later, not a major version of 1 or more.
- Ship sets `docs/about.md`, `product.yml`, and `component.yml` to 0.13.0, tags `v0.12.0` on the commit that `v1.0.0` points at, and deletes `v1.0.0` from `origin`. The human confirmed the tag deletion on 2026-10-25.
- `plan/_archive/` and `plan/changelog/` stay as written. The 0.13.0 change record explains the relabel.

## Acceptance Criteria
- [ ] `grep -rn "2\.0\.0\|in 1\.x\|through 1\.x"` over live files outside `plan/_archive/`, `plan/changelog/`, and this run's `plan/current/` finds no version promise.
- [ ] `test-0000160-req-004-brand-prose.sh` passes on 0.12.0 and 0.13.0 and fails on 0.11.0.
- [ ] A guard test fails if a live file names a 2.0.0 removal point.

## Dependencies
- ADR-005. Ship carries out the tag steps.
