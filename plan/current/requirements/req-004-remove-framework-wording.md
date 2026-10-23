---
title: "Requirement: req-004 - remove-framework-wording"
summary: "Planifest Zero stops describing or naming itself as a framework in every tracked file outside the archive and changelog, in prose and in identifiers."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - remove-framework-wording

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-005
**Priority:** must-have

## User Story

As a reader of any Planifest Zero file, I never see Planifest Zero described or named as a framework, so that "framework" refers only to Planifest Framework or to a generic framework.

## Functional Requirements
- Every tracked file outside `plan/_archive/` and `plan/changelog/` stops describing Planifest Zero as a framework.
  - The reach includes `README.md`, `docs/about.md`, `CLAUDE.md`, skills, standards, templates, workflows, setup scripts, hooks, tests, and `.github/`.
  - Prose that describes Planifest Zero uses "Planifest Zero", "the pack", or "the pipeline", whichever reads best.
- Identifiers that name Planifest Zero as a framework change as well as prose.
  - The identifiers are env and shell variables, JS names, file names, headings, anchors, and test file names.
  - The exact new names come from the identifier name map in ADR-004. This requirement does not fix any final name.
  - Every reference to a renamed identifier changes in the same commit as the rename. This covers links, anchors, `git mv` targets, `regression-manifest.json` entries, and test paths.
- Generic uses stay unchanged:
  - The 22 `test-frameworks.md` standards.
  - The terms "meta-framework" and "test framework".
  - Web, API, and HTTP frameworks in the stack evaluation and `prefer-avoid.md` standards.
  - Any reference to the separate product Planifest Framework, including the repo `planifest/planifest-framework`.
- Files under `plan/_archive/` and `plan/changelog/` stay untouched, because they are history.
- Backlog entries under `plan/backlog/` are in scope, because they are tracked and not archive.
  - An entry changes only where it names Planifest Zero as a framework.
  - On 2026-10-23, no backlog entry contains the word, so no backlog edit is expected.
- A new test greps every tracked file outside `plan/_archive/` and `plan/changelog/` for "framework", case-insensitive.
  - The test fails on any line that does not match an allowlist of generic uses.
  - The allowlist lives in the test file. Each entry names the generic use it covers.
- The files in `plan/current/` for this feature quote the old words to describe the rename.
  - The test skips `plan/current/` for the duration of the feature, because `planifest-ship` moves those files into the archive.
  - ADR-004 records this exemption.
- No migration is needed. This repo is the only install of Planifest Zero.
- REQ-002 lands first, then this requirement edits the same files on top of it.

## Files in reach

Counts come from `git ls-files | grep -v '^plan/_archive/' | grep -v '^plan/changelog/' | xargs grep -il framework`. They exclude `plan/current/`. The prose split is approximate, and the allowlist test gives the exact result.

| Category | Lines | Files | Action |
|----------|-------|-------|--------|
| Prose describing Planifest Zero | about 50 | about 30 | Reword |
| Identifiers naming Planifest Zero | 350 | 83 | Rename per ADR-004 |
| Generic uses | about 220 | about 70 | Keep |
| Total with "framework" in any case | 618 |      150 | |

### Prose describing Planifest Zero

- `README.md` (7 lines, named by the human), `docs/about.md`, `docs/architecture-overview.md`, `docs/dependency-graph.md`, `docs/decisions-index.md`.
- `plan/feature-structure.md`, `planifest-zero/pipeline-reference.md` (6), `planifest-zero/project-operations.md`, `planifest-zero/getting-started.md`.
- `planifest-zero/component.yml` (2), `planifest-zero/templates/` (`component-guide.md`, `standard-boot.md`, `feature-brief.template.md`, `domain-glossary-guide.md`, `component.template.yml`, `loop-toggles.template.yml`).
- Skills: `planifest-migrator`, `planifest-optimise-agent`, `planifest-ship`, `planifest-test-writer`, `planifest-loop-runner`, `planifest-orchestrator`, `planifest-implement`, `planifest-validate-and-accept`, `planifest-refresh-setup`.
- Standards: `language-quirks-en-gb.md` (3), `code-quality-standards.md`, `formatting-standards.md`, `stack-summary.md`.
- Setup and hooks: `planifest-zero/setup.sh` (5), `planifest-zero/setup.ps1` (5), `planifest-zero/hooks/enforcement/ratchet-check.mjs`, `.github/workflows/planifest.yml`.
- Migrations under `planifest-zero/migrations/_done/` (2 files) name "planifest framework" in past records. Treat them as history-like and reword only where a line describes the current pack.
- The `setup.sh` heredoc that writes the project guide holds garbled characters in two lines. Fix the wording on those lines only and leave the encoding to a separate change.

### Identifiers

| Identifier | Kind | Files |
|------------|------|-------|
| `FRAMEWORK` (bare shell variable) | Shell variable | 66 files, mostly `planifest-zero/tests/` and `tests/regression/` |
| `FRAMEWORK_DIR` | Shell variable | `tests/test-0000027-req-003-005-007-008-governance-docs.sh`, `tests/test-0000028-req-004-install-refresh-registration.sh` |
| `FRAMEWORK_SRC` | Shell variable | `tests/test-0000028-req-002-shared-module-extraction.sh` |
| `frameworkDir`, `FrameworkDir` | JS and PowerShell name | `scripts/self-description-check.mjs`, `tests/helpers/setup-workspace.ps1`, `tests/test-0000040-req-002-003-ps1-shape-check.ps1`, `tests/test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` |
| `frameworkPath` | JS name | `hooks/enforcement/auto-trigger-orchestrator.mjs` |
| `extractFrameworkTable` | JS function | `scripts/self-description-check.mjs` |
| `framework-update-policy.md` | File name and links | `standards/framework-update-policy.md`, `skills/planifest-orchestrator/SKILL.md`, `tests/test-0000027-req-003-005-007-008-governance-docs.sh` |
| `updating-the-framework` | Anchor | `getting-started.md`, `project-operations.md`, from the heading "Updating the Framework" in `pipeline-reference.md` and `project-operations.md` |
| `## The framework` | Heading matched by a script | `README.md`, `docs/about.md`, `docs/architecture-overview.md`, `docs/dependency-graph.md`, `plan/feature-structure.md`, `scripts/self-description-check.mjs`, both setup scripts, `skills/planifest-loop-runner/SKILL.md` |
| `-framework-governance` | Test file name | `tests/test-0000005-framework-governance.sh` and its copy under `tests/regression/` |
| `framework-quality-improvements` | Test file name | `tests/test-0000010-framework-quality-improvements.sh` |
| `remove-old-framework` | Test file name | `tests/test-0000037-req-004-remove-old-framework.sh` |
| `framework-pipeline-fixes` | Comment label | `tests/test-0000023-req-001-continuous-run-p1-p3.sh`, `tests/test-0000023-req-002-marker-commit-lifecycle.sh` |
| `stack.framework` | Manifest field in a guide | `templates/component-guide.md` (check against `component.yml` before renaming, because it may name a web framework) |

The heading `## The framework` and the script that parses it must change together. Otherwise `self-description-check.mjs` fails. The rename also touches `tests/regression/regression-manifest.json`, which lists the renamed test files.

### Generic uses (kept)

- 22 `test-frameworks.md` files under `planifest-zero/standards/library-standards/`, plus the lines that link to them.
- `planifest-zero/standards/reference/backend-stack-evaluation.md` (51 lines) and `frontend-stack-evaluation.md` (47 lines).
- Web framework tables in the `prefer-avoid.md` files for `go`, `java`, `nodejs`, `react`, and `python`.
- "meta-framework" in the React `prefer-avoid.md`, "testing framework" in `planifest-validate-and-accept`, and "language or framework in use" in `formatting-standards.md`.
- References to Planifest Framework and `planifest/planifest-framework`, for example in `docs/decisions-index.md` where it records the 0000030 rename.

## Acceptance Criteria
- [ ] (a) The new allowlist test passes. It reports zero lines with "framework" in tracked files outside `plan/_archive/`, `plan/changelog/`, and `plan/current/`, other than allowlisted generic uses.
- [ ] (b) `README.md` and `docs/about.md` contain no line that describes or names Planifest Zero as a framework. The README states that Planifest Zero is distinct from Planifest Framework.
- [ ] (c) Every identifier in the table above uses the name that ADR-004 assigns. No file, link, anchor, or manifest entry refers to an old name.
- [ ] (d) The allowlist test fails when a deliberate line such as "Planifest Zero is a framework" is added to a scratch copy of `README.md`.
- [ ] (e) The 22 `test-frameworks.md` files, the stack evaluation standards, and references to Planifest Framework are unchanged apart from link updates.
- [ ] (f) `git diff --stat` shows no change under `plan/_archive/` or `plan/changelog/`.
- [ ] (g) `run-tests.sh` passes with zero failures, including the renamed tests and `self-description-check.mjs`.

## Dependencies
- REQ-002 (phase-numbers-and-prefixes) edits the same files. It lands first, and this requirement rebases its edits onto the result.
- REQ-003 (product-name-planifest-zero) sets `name: "Planifest Zero"` in `product.yml` and `planifest-zero/component.yml`. This requirement edits `component.yml` prose after REQ-003 lands, so the two edits do not collide.
- ADR-004 holds the identifier name map. P2 must not start renames until ADR-004 is confirmed.
- The decision that "no migration is needed" rests on this repo being the only install. If another install exists, the renamed `FRAMEWORK_DIR` and file names break it.
