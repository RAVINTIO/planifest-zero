---
title: "Requirement: req-004 - remove-old-framework"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-004 - remove-old-framework

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-001
**Priority:** must-have

## User Story

As the maintainer, I delete `planifest-framework/` from the repo, so that the rename suite passes in full.

## Functional Requirements
- Rewrite the `## CI` section of `planifest-zero/tests/README.md` so that it no longer names the old folder or backlog 0000097.
- Run `git config core.hooksPath planifest-zero/hooks` before the deletion, so `commit-msg` stays active (R-005).
- Confirm that `git config core.hooksPath` prints `planifest-zero/hooks`, then run `git rm -r planifest-framework/`.
- Leave records under `plan/`, `CLAUDE.md`, and `docs/decisions-index.md` as they are. The rename suite exempts them.
- Prove the change with the existing suite `planifest-zero/tests/test-0000031-req-001-rename.sh`.
- Add the suite `planifest-zero/tests/test-0000037-req-004-remove-old-framework.sh` for the `git ls-files` and `core.hooksPath` checks.
- In that suite, check `core.hooksPath` only when `CI` is unset. A fresh CI checkout has no local git config, so the check skips there with a note.
- Build the old folder name in that suite by concatenation, as the rename suite does, so it doesn't count as a live reference.

## Acceptance Criteria
- [ ] `planifest-framework/` is absent from the tree, and `git ls-files planifest-framework` prints nothing (AC 1).
- [ ] `bash planifest-zero/tests/test-0000031-req-001-rename.sh` passes cases (a) to (e) (AC 2).
- [ ] `git config core.hooksPath` prints `planifest-zero/hooks` (AC 8).
- [ ] `planifest-zero/tests/README.md` doesn't name the old folder.
- [ ] The req-004 suite passes.

## Dependencies
- req-001, req-002, req-003, req-005, req-007, req-008, and req-009 land first. The old installed skills keep their source files until then.
- req-001 removes the workflow comment that names the old folder. Rename case (b) fails until it does.
- req-006 runs after this requirement, because its job fails until the rename suite passes.
