---
title: "Requirement: REQ-001 - pack-identifiers"
summary: "Rename the pack folder, skills, workflow files, test files, and manifests from planifest to ravintio."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - pack-identifiers

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I find the pack at `ravintio-zero/` with `ravintio-*` skills, so that paths match the RAVINTIO Zero brand.

## Functional Requirements
- Rename `planifest-zero/` to `ravintio-zero/` and `planifest-overrides/` to `ravintio-overrides/`.
- Rename the 12 `planifest-*` skill folders to `ravintio-*`. Update the `name:` field in each `SKILL.md` to match.
- Rename `ravintio-zero/hooks/planifest.yml` and `.github/workflows/planifest.yml` to `ravintio.yml`.
- Rename `refresh-planifest-zero-dir.ps1` to `refresh-ravintio-zero-dir.ps1`.
- Rename every test file whose name contains `planifest` so it contains `ravintio`. Update the matching entries in `tests/regression/regression-manifest.json`.
- Update the `id`, name, and path fields in `product.yml` and `component.yml` from `planifest-zero` to `ravintio-zero`.
- Update the paths in `.gitattributes` to the new folder names.
- Leave `plan/_archive/`, `plan/changelog/`, and `ravintio-zero/migrations/_done/` as written.
- Use history-preserving moves (`git mv`) so file history follows each rename.

## Acceptance Criteria
- [ ] No folder or file name in the repository contains `planifest`, outside `plan/_archive/`, `plan/changelog/`, and `migrations/_done/`.
- [ ] Every `SKILL.md` `name:` field starts with `ravintio-`, and `product.yml`, `component.yml`, `.gitattributes`, and `regression-manifest.json` reference only `ravintio` paths and ids.
- [ ] The history folders `plan/_archive/`, `plan/changelog/`, and `migrations/_done/` have no changes in the diff against `main`.

## Dependencies
- REQ-002 updates the runtime strings that point at these new paths.
- REQ-006 guards the result.
