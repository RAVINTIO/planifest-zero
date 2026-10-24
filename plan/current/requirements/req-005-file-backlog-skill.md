---
title: "Requirement: req-005 - file-backlog-skill"
summary: "A new skill files one uncommitted backlog entry in another repo and leaves that repo's git state untouched."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - file-backlog-skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Source:** US-005
**Priority:** must-have

## User Story

As a human, I ask the agent to file a backlog entry in another repo, and it writes one uncommitted entry folder, so that the repo's git state stays untouched. (Backlog 0000163)

## Functional Requirements
- Add the skill `ravintio-zero/skills/ravintio-file-backlog/SKILL.md`. The frontmatter holds `name: ravintio-file-backlog` and a `description`.
- The skill takes a target repo path and the entry content. It runs these steps in order:
  1. Find `plan/backlog/` in the target repo. Create it if missing.
  2. Read the target repo's backlog template, `ravintio-zero/templates/backlog-entry.template.md` or its equivalent, and its id width. If the repo has neither, use this pack's template.
  3. Pick the next id as the highest ever allocated plus one. Scan `plan/backlog/`, `plan/_archive/`, and `plan/changelog/`. Ids are the leading zero-padded numbers in folder and file names. Use the repo's id width.
  4. If a folder with the same slug already exists, report it and write nothing. Never overwrite an existing folder. If the chosen id is taken, take the next free id.
  5. Write `plan/backlog/{id}-{slug}/entry.md` in that repo's format.
  6. Report the path written.
- The skill never commits, pushes, switches branches, stashes, or opens a pull request in the target repo.
- A write to a target repo outside the current project passes `gate-write` (REQ-001). The skill relies on that and adds no hook change of its own.
- Register the skill in `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-skills-catalogue.md` under "Standalone and Subagent Skills". The row gives the trigger (the human asks to file a backlog entry in another repo) and the relationship (standalone, invoke any time). Setup copies that file into the installed `.claude/skills/ravintio-orchestrator/references/` copy.

## Install and enumeration scope

- `setup.sh` and `setup.ps1` install every folder under `ravintio-zero/skills/` that holds a `SKILL.md` (`copy_skills`). No manifest lists skills, so neither script needs a change.
- Tests that enumerate the skill set change from 12 to 13 skills:
  - `ravintio-zero/tests/test-0000031-req-004-setup-execution.sh` asserts "exactly 12 skills installed" twice.
  - `ravintio-zero/tests/test-0000031-req-003-five-phases.sh` names 12 skills in its header and loop. Add `ravintio-file-backlog`.
- The installed `.claude/skills/` copy refreshes when the maintainer re-runs setup.

## Tests
- Add a structure suite for the skill. It asserts:
  - the frontmatter holds `name: ravintio-file-backlog` matching the folder, and a non-empty `description`.
  - the text states the never-commit rule, naming commit, push, branch switch, stash, and pull request.
  - the text states the id rule: highest ever allocated plus one, scanning `plan/backlog/`, `plan/_archive/`, and `plan/changelog/`.
  - the text states the existing-slug rule and the never-overwrite rule.
- Assert the catalogue holds a row for the skill.

## Acceptance Criteria
- [ ] `ravintio-zero/skills/ravintio-file-backlog/SKILL.md` exists with a `name` equal to its folder and a non-empty `description`, and setup installs it in both shells.
- [ ] The skill text states the next-id rule (highest ever allocated plus one across `plan/backlog/`, `plan/_archive/`, and `plan/changelog/`), the existing-slug report-and-stop rule, and the never-overwrite rule. A structure test asserts each.
- [ ] The skill text states that it never commits, pushes, switches branches, stashes, or opens a pull request in the target repo, and that it reports the path written. A structure test asserts the rule.
- [ ] The skills catalogue lists `ravintio-file-backlog`, and the skill-count suites expect 13 skills and pass.

## Dependencies
- REQ-001 (gate-write-outside-project) lets a write to a repo outside the project pass `gate-write`.
- The pack's `ravintio-zero/templates/backlog-entry.template.md` is the fallback format.
