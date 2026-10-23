---
title: "Requirement: req-008 - framework-prose"
summary: "Prose in tracked files stops describing Planifest Zero as a framework and uses Planifest Zero, the pack, or the pipeline."
status: "active"
version: "0.1.0"
---
# Requirement: req-008 - framework-prose

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-005
**Priority:** must-have

## User Story

As a reader of any Planifest Zero file, I never see Planifest Zero described as a framework, so that "framework" refers only to Planifest Framework or to a generic framework.

## Functional Requirements
- Prose that describes Planifest Zero as a framework changes in every tracked file outside `plan/_archive/` and `plan/changelog/`.
  - The reach includes `README.md`, `docs/`, `CLAUDE.md`, skills, standards, templates, workflows, setup output, hooks, and `.github/`.
  - New wording uses "Planifest Zero", "the pack", or "the pipeline", whichever reads best.
  - The README states that Planifest Zero is distinct from Planifest Framework.
- Generic uses stay unchanged:
  - The 21 `test-frameworks.md` standards.
  - The terms "meta-framework" and "test framework".
  - Web, API, and HTTP frameworks in the stack evaluation and `prefer-avoid.md` standards.
  - The `stack.framework` field, which names a web framework in the user's stack.
  - Any reference to the separate product Planifest Framework, including the repo `planifest/planifest-framework`.
- Files under `plan/_archive/` and `plan/changelog/` stay untouched, because they are history.
- Backlog entries under `plan/backlog/` change only where they name Planifest Zero as a framework. On 2026-10-23, no backlog edit is expected.
- The `setup.sh` heredoc that writes the project guide holds garbled characters in two lines. Fix the wording on those lines only and leave the encoding to a separate change.
- Migrations under `planifest-zero/migrations/_done/` are past records. Reword only where a line describes the current pack.
- The line in `planifest-zero/component.yml` that says "the framework's own behaviour" becomes "the pack's own behaviour".
- No migration is needed. This repo is the only install of Planifest Zero.

## Files in reach

Counts come from `git ls-files | grep -v '^plan/_archive/' | grep -v '^plan/changelog/' | xargs grep -il framework`. They exclude `plan/current/`. The split is approximate, and the allowlist test in REQ-010 gives the exact result.

| Category | Lines | Files | Action |
|----------|-------|-------|--------|
| Prose describing Planifest Zero | about 50 | about 30 | Reword |
| Generic uses | about 220 | about 70 | Keep |

### Prose describing Planifest Zero

- `README.md` (7 lines, named by the human), `docs/about.md`, `docs/architecture-overview.md`, `docs/dependency-graph.md`, `docs/decisions-index.md`.
- `plan/feature-structure.md`, `planifest-zero/pipeline-reference.md` (6), `planifest-zero/project-operations.md`, `planifest-zero/getting-started.md`.
- `planifest-zero/component.yml` (2), `planifest-zero/templates/` (`component-guide.md`, `standard-boot.md`, `feature-brief.template.md`, `domain-glossary-guide.md`, `component.template.yml`, `loop-toggles.template.yml`).
- Skills: `planifest-migrator`, `planifest-optimise-agent`, `planifest-ship`, `planifest-test-writer`, `planifest-loop-runner`, `planifest-orchestrator`, `planifest-implement`, `planifest-validate-and-accept`, `planifest-refresh-setup`.
- Standards: `language-quirks-en-gb.md` (3), `code-quality-standards.md`, `formatting-standards.md`, `stack-summary.md`.
- Setup and hooks: `planifest-zero/setup.sh` (5), `planifest-zero/setup.ps1` (5), `planifest-zero/hooks/enforcement/ratchet-check.mjs`, `.github/workflows/planifest.yml`.
- `planifest-zero/migrations/_done/` (2 files).

### Generic uses (kept)

- 21 `test-frameworks.md` files under `planifest-zero/standards/library-standards/`, plus the lines that link to them.
- `planifest-zero/standards/reference/backend-stack-evaluation.md` (51 lines) and `frontend-stack-evaluation.md` (47 lines).
- Web framework tables in the `prefer-avoid.md` files for `go`, `java`, `nodejs`, `react`, and `python`.
- "meta-framework" in the React `prefer-avoid.md`, "testing framework" in `planifest-validate-and-accept`, and "language or framework in use" in `formatting-standards.md`.
- The `stack.framework`, `stack.frontend`, and `stack.testing` lines in `templates/component-guide.md` and `templates/component.template.yml`.
- References to Planifest Framework and `planifest/planifest-framework`, for example in `docs/decisions-index.md` where it records the 0000030 rename.

## Acceptance Criteria
- [ ] (a) `README.md` and `docs/about.md` contain no line that describes or names Planifest Zero as a framework. The README states that Planifest Zero is distinct from Planifest Framework.
- [ ] (b) Every other prose line in the files listed above that describes Planifest Zero as a framework now says "Planifest Zero", "the pack", or "the pipeline".
- [ ] (c) The 21 `test-frameworks.md` files, the stack evaluation standards, and references to Planifest Framework are unchanged apart from link updates.

## Dependencies
- Run modes (REQ-001 to REQ-003) edit some of the same files. They land before this requirement.
- Phase numbers (REQ-004 to REQ-006) edit the same files. They land first, and this requirement rebases its edits onto the result.
- Product name (REQ-007) sets `name: "Planifest Zero"` in `product.yml` and `planifest-zero/component.yml`. This requirement edits `component.yml` prose after REQ-007 lands, so the two edits do not collide.
- REQ-009 renames identifiers in some of the same files. REQ-010 enforces the result.
- The decision that "no migration is needed" rests on this repo being the only install.
