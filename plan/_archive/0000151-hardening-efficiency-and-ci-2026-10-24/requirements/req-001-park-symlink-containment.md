---
title: "Requirement: req-001 - park-symlink-containment"
summary: "Park refuses to write or delete when any part of the entry path is a symlink or escapes the real plan/backlog folder."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - park-symlink-containment

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I park a feature without `park.mjs` writing or deleting files outside the repo, so that a symlink on `main` cannot reach my file system.

## Functional Requirements
- `finishPr` in `planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` checks the entry path on the chore branch, after `git checkout -B` and before any file call.
  - The existing text check in `parkContext` stays. It does not follow symlinks, so it cannot be the only check.
- The new check resolves the real location of the entry folder with `realpathSync`.
  - The folder may not exist yet. The check then resolves the nearest existing ancestor and appends the missing names.
  - The result must sit under the real path of `plan/backlog/`.
- The check also refuses when any existing part of the path is a symlink.
  - It tests `plan`, `plan/backlog`, the entry folder, and `entry.md` with `lstatSync`.
  - A symlink that points inside the repo is also refused.
- The check runs at three points:
  - before `mkdirSync`
  - before `writeFileSync`
  - before the `rmSync` in `removeEntry`
- A refusal throws a `ParkError` that names the path part and says it is a symlink or leaves `plan/backlog/`.
  - The refusal at `removeEntry` skips the delete and still lets the caller rethrow the original error.
- A refusal pushes nothing and raises no PR. Park then returns the working tree to the feature branch, as it does for any other failure.
- A normal park, with no symlink, behaves as before.

## Acceptance Criteria
- [ ] (a) Park refuses every unsafe symlink and leaves its target unchanged. All of these hold:
  - With a symlink committed to `origin/main` at `plan/backlog` that points to a folder outside the repo, park exits non-zero with the refusal message. The file `outside/0000900-park-demo/entry.md` keeps its bytes and still exists.
  - With a real `plan/backlog` and a symlink committed at `plan/backlog/0000900-park-demo` that points outside the repo, park exits non-zero with the refusal message. The outside `entry.md` keeps its bytes and still exists.
  - With a symlink committed at `plan/backlog/0000900-park-demo/entry.md`, park refuses and leaves the link target unchanged.
  - In the three symlink cases above (a symlinked `plan/backlog`, a symlinked entry folder, and a symlinked `entry.md`), the stub `gh` log holds no `pr create` line, `origin` gains no `chore/park-*` branch, and the working tree is on the feature branch afterwards.
  - A symlink at the entry folder that points to another folder inside the repo is also refused.
- [ ] (b) Commit failure with a symlink at the entry path is handled safely. All of these hold:
  - When the chore commit fails and the entry path holds a symlink, `removeEntry` does not delete through the link, and park rethrows the original commit error.
- [ ] (c) Existing behaviour is unchanged. All of these hold:
  - The existing park tests `test-0000040-req-004-005-park.sh` and `test-0000041-req-004-park-commit-failure.sh` still pass unchanged, so the normal park and the commit-failure cleanup keep working.

## Dependencies
- Backlog source 0000142 (`plan/current/backlog-sources/0000142-park-entry-path-follows-symlinks.md`) holds the confirmed finding.
- The 0000040 containment design and the 0000041 cleanup design set the checks this requirement extends.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` (`parkContext` at 107-130, `removeEntry` at 154-162, `finishPr` from 166)
  - `planifest-zero/tests/test-0000151-req-001-park-symlink-containment.sh` (new, models the bare `origin` plus seed repo set-up of `test-0000040-req-004-005-park.sh` and `test-0000041-req-004-park-commit-failure.sh`, with a stub `gh`)
  - `planifest-zero/tests/helpers/assert.sh` (existing test helpers)
  - `planifest-zero/skills/planifest-orchestrator/` docs that describe park containment, updated if the wording changes

## Input Validation

- [ ] Input source: the entry path under the checked-out chore branch, which comes from `origin/main` and so is untrusted
- [ ] Allowed character pattern: the entry folder name keeps the existing `{backlog-id}-park-{slug}` form with a seven-digit id and the existing slug pattern. Any path part that is a symlink is refused
- [ ] maximum length: the refusal message names one path part, truncated to 200 characters
- [ ] Failure behaviour: refuse with a `ParkError`, make no write and no delete, push nothing, and return to the feature branch
- [ ] Logging policy: the message prints the repo-relative path part only, never the link target or any file content
