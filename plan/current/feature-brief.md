---
title: "Feature Brief - ravintio-rebrand"
summary: "Rebrand Planifest Zero to RAVINTIO Zero across code, docs, and GitHub."
status: "draft"
version: "1.0.0"
---
# Feature Brief - ravintio-rebrand

**Feature ID:** 0000160-ravintio-rebrand

## Business Goal

The product joins the RAVINTIO ecosystem as RAVINTIO Zero, beside RAVINTIO Framework, Accept, and Assess. Every name a user sees or types must carry the new brand. Installed consumer repos must upgrade without losing their overrides or plan history.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pack identifiers | As a maintainer, I find the pack at `ravintio-zero/` with `ravintio-*` skills, so that paths match the brand | must-have | 1 |
| Runtime names | As a consumer, I get hooks, setup, and scripts that detect and write `ravintio` names, so that enforcement keeps working after the rename | must-have | 1 |
| Environment variables | As a roadmap user, I set `RAVINTIO_*` variables, and my old `PLANIFEST_ROADMAP_*` values still work for this major version | must-have | 1 |
| Brand prose | As a reader, I see "RAVINTIO Zero" in every doc, skill, template, and message | must-have | 1 |
| Consumer migration | As a consumer, I run one migration that moves my overrides and workflow and removes old markers, so that my upgrade is safe | must-have | 1 |
| Brand guard | As a maintainer, I get a failing test when "planifest" reappears outside history and the allowlist | must-have | 1 |

## Waves

One wave. A half-renamed pack fails its own tests, so the rename cannot split.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero (was planifest-zero) | component-pack | existing | The drop-in pipeline pack |

### Data Ownership

None.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| GitHub org `planifest` | GitHub org `ravintio` | Human rename in org Settings | Old URLs redirect |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node.js ESM, Markdown |
| Testing | Bash and PowerShell suites under the pack's `tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Rename the pack folder, overrides folder, skills, marker files, workflow file, refresh script, and test file names.
- Rename runtime matches in hooks, setup, scripts, and CI.
- Rename `PLANIFEST_*` to `RAVINTIO_*`, with a fallback for the two roadmap variables.
- Replace the brand in prose with "RAVINTIO Zero". Sibling products become RAVINTIO Framework.
- Repoint GitHub links to the `ravintio` org.
- A migration with Bash and PowerShell helpers for installed consumers.
- A guard test that blocks the old name outside history.
- Version 1.0.0.

### Out of Scope
- `plan/_archive/`, `plan/changelog/`, and `planifest-zero/migrations/_done/`. They stay as written.
- The sibling repos. Their own renames are separate work.
- The local clone folder `~/d/planifest/zero`.
- Backlog items 0000095, 0000100, 0000110, and 0000159.

### Deferred
- The org rename and the repo rename. The human renames the org in GitHub Settings. The agent runs `gh repo rename ravintio-zero` after the PR merges. Links to the new org fail until the org rename lands.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Residual brand | 0 tracked lines match "planifest" (case-insensitive) outside history and the allowlist | Guard test |
| Regression | Every existing suite passes on Bash, Windows PowerShell 5.1, and PowerShell 7 | CI matrix |

## Constraints and Assumptions

### Constraints
- Prose writes the brand as RAVINTIO in block caps. Identifiers stay lowercase `ravintio`. Environment variables use `RAVINTIO_`.
- History records stay untouched.

### Assumptions
- Sibling repos keep their current repo names after the org rename.

## Scenario Paths

Drafts live in the build log Scope Lock lines once confirmed.

## Acceptance Criteria

- [ ] No tracked path outside history contains "planifest".
- [ ] A fresh `setup.sh claude-code` and `setup.ps1 claude-code` install `ravintio-*` skills and working hooks.
- [ ] The migration upgrades a planifest-named consumer fixture and keeps its overrides.
- [ ] The guard test fails on a planted "Planifest" line.
- [ ] All suites pass in CI.
