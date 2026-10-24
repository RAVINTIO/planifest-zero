---
title: "Requirement: req-011 - orchestrator-references-split"
summary: "Rarely used orchestrator sections move into references files that load on demand, so a fresh session starts smaller and no rule is lost."
status: "draft"
version: "0.1.0"
---
# Requirement: req-011 - orchestrator-references-split

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (backlog 0000148)
**Priority:** must-have

## User Story

As the person paying for runs, I get a smaller starting context in every fresh session, so that each roadmap step and each new session costs fewer tokens before its first tool call.

## Functional Requirements
- Measure the starting context before the change and after it.
  - The measure is the byte count of `CLAUDE.md` plus `planifest-zero/skills/planifest-orchestrator/SKILL.md`.
  - The baseline is 44,538 bytes in total: 8,322 for `CLAUDE.md` and 36,216 for `SKILL.md`.
  - The build log records both figures and the saving.
- Move these sections out of `SKILL.md` into files under `planifest-zero/skills/planifest-orchestrator/references/`:
  - Adoption Modes
  - Retrofit Scan
  - Pause Command
  - Park Command
  - Phase Skip Protocol
  - Standalone and Subagent Skills
  - Capability Skills
  - Mid-Pipeline Requirement Changes
- If those sections do not reach the target below, move more sections that are not on the inline list. Audit Trail and Skill Map are the next candidates.
- Keep these sections inline in `SKILL.md`:
  - Hard Limits
  - Resume Detection
  - Discovery Start Actions
  - Exception Stops
  - Phase Invocation
  - Subagent Dispatch
  - the Pack Index itself
  - the context-size rule from REQ-009
- Register each moved file in the Pack Index.
  - Each row names the file and gives a one-line trigger that says when to read it.
  - Each trigger says to read the file before acting on that topic, so no rule is skipped.
- Move text. Never delete or reword a rule line.
  - Heading levels and heading text may change.
  - Where a moved section leaves a gap, `SKILL.md` keeps a pointer to the Pack Index row.
- Setup must carry the new files into an installed skill.
  - `setup.sh` already copies a skill's `references/` folder (`cp -r`). `setup.ps1` does the same with `Copy-Item -Recurse`.
  - Confirm with a test that a fresh install holds every new `references/` file.
  - Setup rewrites `../standards/` links only inside `SKILL.md`. Moved text must not rely on that rewrite, so write links in the form that already works in an installed copy.
  - Name each file with an `orchestrator-` prefix, so it cannot collide with a standard that setup copies into the same `references/` folder.
- Update every test that greps a moved string so that it reads the new file.
  - Each such test keeps every assertion, with the same pattern and the same expected result.
  - The implementer lists the affected tests, found by grepping each moved string across `planifest-zero/tests/`. Many of the tests that name the orchestrator `SKILL.md` are candidates.
  - A shared helper may read `SKILL.md` and the `references/` files as one text, so an assertion needs only a path change.
- The implementer updates any other file that cites a moved section by heading, such as other skills, standards, and docs.

## Acceptance Criteria
- [ ] (a) `SKILL.md` is at least 25% smaller than 36,216 bytes, which means 27,162 bytes or fewer. The combined size of `CLAUDE.md` and `SKILL.md` is 35,484 bytes or fewer.
- [ ] (b) A script or test proves no rule line was lost. Every non-blank line of the old `SKILL.md` (taken from git at the base commit) appears in the new `SKILL.md` or in a `references/` file. The check ignores heading lines only.
- [ ] (c) The proof in (b) fails when the test removes one non-heading line from a moved file. The test shows this with a mutation case.
- [ ] (d) The Pack Index lists every new `references/` file with a one-line trigger. A test fails if a file under `references/` has no Pack Index row.
- [ ] (e) Each section on the inline list is present in `SKILL.md` with its original text.
- [ ] (f) Every test that read a moved string passes against the new location. A diff of the test files shows paths changed and no assertion removed or loosened.
- [ ] (g) The full suite passes, including the PowerShell suites.
- [ ] (h) A fresh run of `setup.sh` installs every new `references/` file under `.claude/skills/planifest-orchestrator/references/`. A test covers `setup.sh`, and the PowerShell suite covers `setup.ps1`.
- [ ] (i) The build log records the before and after byte counts and the percentage saved.
- [ ] (j) No gate, hard limit, or exception stop is weaker. The inline list in the requirements above is intact, and no moved text drops a rule.

## Dependencies
- REQ-009 adds the context-size rule. Place it inline so the split never moves it.
- REQ-007 (dispatch model tiers) edits the Subagent Dispatch section. That section stays inline, so the two requirements do not collide. Land one, then rebase the other.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (edit)
  - `planifest-zero/skills/planifest-orchestrator/references/` (new files, plus the existing `.gitkeep`)
  - `planifest-zero/setup.sh` and `planifest-zero/setup.ps1` (read to confirm the copy. Edit only if a gap shows)
  - `planifest-zero/tests/test-0000151-req-011-orchestrator-references-split.sh` (new: size target, line-preservation proof, Pack Index check, install check)
  - Existing tests that grep a moved string (edit paths only)
- Docs: a short note in the orchestrator's component docs says which sections now live in `references/` and why.
