---
title: "Requirement: req-009 - framework-identifiers"
summary: "Identifiers and file names that name Planifest Zero as a framework change to the names in the ADR-004 map."
status: "active"
version: "0.1.0"
---
# Requirement: req-009 - framework-identifiers

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer of Planifest Zero, I see no identifier or file name that calls Planifest Zero a framework, so that code and prose use the same words.

## Functional Requirements
- Identifiers and file names that name Planifest Zero as a framework change to the names in the identifier name map in ADR-004.
  - The identifiers are env and shell variables, JS and PowerShell names, file names, headings, anchors, and test file names.
  - ADR-004 fixes the final names. This requirement does not restate them.
  - Shell variables `FRAMEWORK`, `FRAMEWORK_DIR`, and `FRAMEWORK_SRC` become `ZERO_DIR`.
- Every reference to a renamed identifier changes in the same commit as the rename. This covers links, anchors, `git mv` targets, `regression-manifest.json` entries, header comments, and test paths.
- Test file renames use `git mv`. They cover the `tests/` and `tests/regression/` copies, and the `name` and `filePath` entries in `tests/regression/regression-manifest.json`.
- The heading `## The pack` in `README.md` and the parser in `scripts/self-description-check.mjs` change in one commit. Otherwise the check fails with "table not found".
  - `tests/test-0000019-req-005-self-description-check.sh` updates its three fixtures in the same commit.
- Names that stay:
  - `stack.framework`, because it is generic.
  - The `sourceFeature` history ids in `regression-manifest.json`, such as `0000005-framework-governance`.
  - The 0000030 `framework-cut-down` lines in `docs/decisions-index.md`.
- P2 must not start renames until ADR-004 is accepted.

## Files in reach

Counts come from `git ls-files | grep -v '^plan/_archive/' | grep -v '^plan/changelog/' | xargs grep -il framework`. They exclude `plan/current/`.

| Category | Lines | Files | Action |
|----------|-------|-------|--------|
| Identifiers naming Planifest Zero | 350 | 83 | Rename per ADR-004 |

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
| `## The framework` | Heading matched by a script | `README.md`, `scripts/self-description-check.mjs`, `tests/test-0000019-req-005-self-description-check.sh` |
| `-framework-governance` | Test file name | `tests/test-0000005-framework-governance.sh` and its copy under `tests/regression/` |
| `framework-quality-improvements` | Test file name | `tests/test-0000010-framework-quality-improvements.sh` |
| `remove-old-framework` | Test file name | `tests/test-0000037-req-004-remove-old-framework.sh` |
| `framework-pipeline-fixes` | Comment label | `tests/test-0000023-req-001-continuous-run-p1-p3.sh`, `tests/test-0000023-req-002-marker-commit-lifecycle.sh` |

## Acceptance Criteria
- [ ] (a) Every identifier in the table above uses the name that ADR-004 assigns. No file, link, anchor, or manifest entry refers to an old name.
- [ ] (b) The `## The pack` heading and `self-description-check.mjs` change together, and `self-description-check.mjs` passes against the new heading.
- [ ] (c) `run-tests.sh` passes with zero failures, including the renamed tests.

## Dependencies
- Run modes (REQ-001 to REQ-003) edit some of the same files. They land before this requirement.
- Phase numbers (REQ-004 to REQ-006) edit the same files. They land first, and this requirement rebases its edits onto the result.
- Product name (REQ-007) sets the product name. It lands before this requirement edits `component.yml`.
- ADR-004 holds the identifier name map. P2 must not start renames until ADR-004 is accepted.
- REQ-010 enforces the result.
- If another install of Planifest Zero exists, the renamed `ZERO_DIR`, `pack-update-policy.md`, and test paths break it.
