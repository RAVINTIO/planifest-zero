---
title: "Feature Brief - name the roadmap initiative"
summary: "Separate the roadmap, the long-term plan, from the roadmap initiative, the charted unit that ships in one PR."
status: "draft"
version: "0.1.0"
---
# Feature Brief - name the roadmap initiative

**Feature ID:** 0000189-name-the-roadmap-initiative

Source: backlog entry 0000188-name-the-roadmap-initiative, pulled in at P0 and refined by the P0 exchanges in `build-log.md`.

## Business Goal

The pack uses "roadmap" for two things: the long-term plan, and one charted set of feature steps that ships in one PR. The human on the loop needs one word for each, so that the docs, the skills, and every name in the pack say what they mean. This feature defines "roadmap" and "roadmap initiative", renames every name that means the charted unit, and lands before the next initiative activates.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Glossary | As a maintainer, I read one glossary that defines "roadmap" and "roadmap initiative" and the four initiative states, so that I use each word for one thing. | must-have | 1 |
| Renamed names | As a maintainer, I find the initiative under `initiative` names in paths, files, scripts, the branch pattern, env vars, logs, and telemetry, so that each name says what it holds. | must-have | 1 |
| Initiative prefixes | As a maintainer, I see `I-A Chart:` to `I-E Delivery:` on initiative stage messages, so that the prefix names the initiative. | must-have | 1 |
| Initiative states | As a maintainer, I see an initiative's state as proposed, charted, active, delivered, or blocked, so that its status matches the lifecycle. | must-have | 1 |
| Consumer migration | As a consumer, I run migration 0005 to move my drafts and CI pattern to the new names, so that an upgrade keeps my open drafts. | must-have | 1 |
| Old-name guard | As a maintainer, I get a failing test when an old name comes back, so that the rename stays complete. | must-have | 1 |
| Open entries | As the agent running the next initiative, I read open backlog entries in the new terms, so that no step needs to translate them. | must-have | 1 |

## Waves

One wave. The changes rename the same files, so splitting them would leave the pack half renamed between runs.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack: skills, standards, templates, scripts, hooks, tests, and docs |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| initiative driver | `claude -p` step sessions | process spawn | Env vars, model and turn cap, telemetry labels, step logs |
| merge-guard hook | `gh pr merge` | PreToolUse hook | Allows `--squash` only for an `initiative/*` base |
| CI workflow template | GitHub Actions | workflow trigger | Runs on pull requests to `initiative/**` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Node.js ESM, Bash 3.2, PowerShell 5.1 and 7 |
| Runtime | Node 20 or later |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash and Node test scripts under `ravintio-zero/tests/` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions on Linux, macOS, and Windows |
| Build target | local |

## Scope Boundaries

### In Scope

- A glossary entry for "roadmap" and "roadmap initiative", with the four states, in the pack docs and `ravintio-zero/project-operations.md`.
- The renames in the P0 naming table (`build-log.md`, exchange "names").
- Activation moves an initiative to `plan/current-initiative/initiative.md`.
- Prefixes `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, `I-E Delivery:`.
- Template status: `proposed | charted | active | delivered | blocked`.
- Prose in skills, standards, templates, and docs uses "initiative" for the charted unit.
- Migration `0005` for consumers, which stops while a roadmap is active.
- The driver stops with the new name when an old `RAVINTIO_ROADMAP_*` variable is set.
- A search test for old names outside an allowlist.
- New wording in the open backlog entries 0000174 to 0000186.
- Running setup so `.claude/skills/` matches `ravintio-zero/skills/`.

### Out of Scope

- The `ravintio-initiative` skill and its progress reports (backlog 0000182).
- New prefix enforcement, such as a `Stop` hook (backlog 0000181).
- Aliases for the old names.
- Renaming `roadmap-standards.md` or historical test files.
- Editing `plan/_archive/` or `plan/changelog/`.

### Deferred

- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Rename completeness | 0 old names outside the allowlist | The new search test |
| Regression | Full suite passes on Linux, macOS, and Windows, with no test removed | CI on the PR, and a count of test files before and after |

## Constraints and Assumptions

### Constraints

- No commits to `main`. The human merges the PR.
- Bash 3.2 and Windows PowerShell 5.1 compatibility, as for every pack script.
- No active roadmap exists while this feature runs.

### Assumptions

- This repo is the only consumer of the pack today.

## Scenario Paths

**Happy path:**

> A charted initiative lives at `plan/roadmap/{id}-{slug}/initiative.md` with status `charted`. `I-B Activate` cuts `initiative/{id}-{slug}` and moves the file to `plan/current-initiative/`. The driver runs each step, and `I-E Delivery` raises the PR to `main`. Only the new names and the `I-` prefixes appear.

**First-run path:**

> This repo has no draft and no active roadmap, so nothing migrates. In a consumer, migration `0005` runs once at upgrade. It renames each draft's `roadmap.md` and the CI pattern, then moves to `_done/`. A rerun changes nothing.

**Error / sad path:**

> A missed old name fails the search test in CI, which names the file and line. An old `RAVINTIO_ROADMAP_*` variable stops the driver at start. An active roadmap stops migration `0005`.

**Cross-session continuity:**

> `plan/current/` and the build log carry the state. Each rename unit lands in its own commit, so a rerun finishes a partial rename. Migration `0005` refuses to run while a roadmap is active.

## Acceptance Criteria

- [ ] One glossary defines "roadmap", "roadmap initiative", and the four initiative states, and `project-operations.md` explains them.
- [ ] Every name in the P0 naming table uses its new form, and the driver, `merge-guard`, and CI template tests pass with the new names.
- [ ] Initiative stage messages use `I-A` to `I-E`, and the prefix test checks them.
- [ ] The initiative template's status field takes `proposed | charted | active | delivered | blocked`.
- [ ] Migration `0005` renames a draft's `roadmap.md` to `initiative.md` and the CI pattern to `initiative/**`, and stops while `plan/current-roadmap/` exists.
- [ ] The driver stops and names the new variable when `RAVINTIO_ROADMAP_MODEL` or `RAVINTIO_ROADMAP_MAX_TURNS` is set.
- [ ] The search test finds 0 old names outside the allowlist, and fails when one is planted.
- [ ] The open backlog entries use the new terms.
- [ ] The full suite passes in CI on all three platforms, with no test removed.
