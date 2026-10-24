---
title: "Requirement: req-004 - brand-prose"
summary: "Every reader-facing document, message, and label says RAVINTIO instead of Planifest, and links point to the ravintio org."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - brand-prose

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Source:** US-004
**Priority:** must-have

## User Story

As a reader, I see "RAVINTIO Zero" in every doc, skill, template, and message, so that the product name is consistent.

## Functional Requirements
- Replace the brand in prose in these places:
  - `README.md` and `docs/`.
  - The top-level `.md` files of the pack.
  - Skills, templates, and standards.
  - The `$comment` fields in schemas.
  - CI job names and step names.
  - Layout text that setup generates.
  - Hook messages.
- Apply these replacements in order:
  - "Planifest Framework" becomes "RAVINTIO Framework".
  - "Planifest Zero" becomes "RAVINTIO Zero".
  - A bare "Planifest" becomes "RAVINTIO".
- Write the brand in block capitals in prose. Identifiers keep lowercase `ravintio`.
- Move GitHub links from `github.com/planifest/...` to `github.com/ravintio/...`. Sibling repo names stay unchanged.
- Move Pages links from `planifest.github.io/...` to `ravintio.github.io/...`.
- Record version 1.0.0 in `docs/about.md`, `product.yml`, and `component.yml` at ship.
- Leave history folders untouched: `plan/_archive/`, `plan/changelog/`, and `ravintio-zero/migrations/_done/`.
- Keep the existing mojibake in `setup.ps1` near line 1010 byte-identical. Only the brand token on that line may change.
- Make each replacement with a byte-exact tool, not an editor that re-encodes the file.

## Acceptance Criteria
- [ ] The brand guard test (REQ-006) passes, so no tracked file outside history and the allowlist contains "planifest".
- [ ] `git diff` of `setup.ps1` near line 1010 changes only the brand token, and the surrounding bytes match the previous commit.
- [ ] `docs/about.md`, `product.yml`, and `component.yml` record version 1.0.0, and the history folders have no diff.

## Dependencies
- REQ-001 (pack-identifiers) provides the renamed paths that the links and layout text refer to.
- REQ-006 (brand-guard) is the check that proves this requirement.
