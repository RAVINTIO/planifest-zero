---
title: "Feature Brief - release hygiene"
summary: "Two backlog entries: no AI attribution in PR descriptions, and release tags on main."
status: "approved"
version: "0.14.0"
---
# Feature Brief - release hygiene

**Feature ID:** 0000169-release-hygiene

## Business Goal

PR descriptions can carry AI attribution lines, because the ban covers commits only and nothing checks a PR body. Release tags also name feature-branch commits that a squash merge leaves off `main`. This release closes both gaps.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| No attribution in PR descriptions (0000166) | As a maintainer, I see no AI attribution lines in any PR description, so that PRs follow the same rule as commits. | must-have | 1 |
| Release tags on main (0000167) | As a maintainer, I see every release tag on a commit that `git log main` shows, so that a tag always names shipped code. | must-have | 1 |

## Acceptance criteria

1. The boot template, the commit standards, and the ship skill ban attribution in PR descriptions and name the host lines to leave out.
2. A check script exits 1 when a text holds an attribution line and 0 when it holds none. Ship runs it on the PR body, and the CI `validate-branch` job runs it on the PR description.
3. Setup sets the Claude Code `attribution` setting to empty `commit` and `pr` strings when the key is absent, and leaves a human-set value alone.
4. Ship no longer tags before the merge. A CI job on a push to `main` tags the pushed commit with the version from `product.yml`, and skips when that tag exists.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The drop-in pipeline pack: skills, hooks, setup, templates, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | | |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| GitHub Actions | `check-attribution.mjs` | PR event body in an environment variable | exit 0 or 1 |
| GitHub Actions | `release-tag.mjs` | push to `main` | exit 0, tag pushed or skipped |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell 5.1 and 7, Node.js ESM, Markdown, GitHub Actions YAML |
| Testing | Shell and PowerShell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Attribution ban text for PR descriptions in the boot template, commit standards, and ship skill.
- `ravintio-zero/scripts/check-attribution.mjs`, used by ship and by CI. The `commit-msg` hook gains the host-line patterns.
- Setup writes the `attribution` setting in both shells.
- `ravintio-zero/scripts/release-tag.mjs` and a `release-tag` CI job on a push to `main`, in the repo workflow and the consumer template.
- Ship Steps 7, 9, and 10, `roadmap-standards.md`, `pipeline-reference.md`, and `custom-004` match the new tag flow.

### Out of Scope
- Moving tags that already exist. The human moved every release tag onto `main` on 2026-10-25.
- Updating a consumer's existing `.github/workflows/ravintio.yml`. Setup copies the template only when the file is absent.
- Other backlog entries.

### Deferred
- Nothing deferred.
