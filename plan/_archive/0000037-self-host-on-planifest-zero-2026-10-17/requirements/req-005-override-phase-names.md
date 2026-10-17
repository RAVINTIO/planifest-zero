---
title: "Requirement: req-005 - override-phase-names"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-005 - override-phase-names

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** Scope Lock gap found at P0, supports US-001
**Priority:** must-have

## User Story

As the maintainer, I read the push-and-PR override, so that it names a phase the five-phase pipeline has.

## Functional Requirements
- In `planifest-overrides/instructions/custom-004-p9-push-and-raise-pr.md`, replace "At P9" with wording that names the ship phase. Use "the ship phase", not a phase number, so the text holds for any phase count.
- Keep the filename. `CLAUDE.md` shows the old wording until the post-merge reinstall regenerates it.
- Remove every other phase number from the file that belongs to the old nine-phase pipeline.
- Keep the rules as they are: push the branch and tag, run `gh pr create`, take option [1], never merge, and stop on a failed push.
- Option [1] still matches the push and PR choice in `planifest-zero/skills/planifest-ship/SKILL.md`.
- Add the suite `planifest-zero/tests/test-0000037-req-005-override-phase-names.sh`. If the override file is absent, it skips.

## Acceptance Criteria
- [ ] The override file names the ship phase (AC 9).
- [ ] The file body contains no `P9` (AC 9).
- [ ] The file still contains `gh pr create`, `option [1]`, and the rule never to merge.
- [ ] The req-005 suite passes.

## Dependencies
- None. It runs in parallel with req-001, req-002, req-003, and req-009 at P3.
