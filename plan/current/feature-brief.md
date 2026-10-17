---
title: "Feature Brief - self-host-on-planifest-zero"
summary: "Switch this repo from the old planifest-framework/ copy to planifest-zero/."
---
# Feature Brief - self-host-on-planifest-zero

**Feature ID:** 0000037-self-host-on-planifest-zero
**Source:** backlog 0000097, which absorbs 0000086, 0000089, and 0000093

## Business Goal

This repo ships `planifest-zero/`, but it runs its own pipeline on `planifest-framework/`. That older copy keeps the rename suite failing and keeps retired telemetry in CI. Removing it means the repo runs on the product it ships.

## Features

- US-001: As the maintainer, I delete `planifest-framework/` from the repo, so that the rename suite passes in full.
- US-002: As the maintainer, I keep this repo's setup record at `plan/state/claude-code.md`, so that it matches what `planifest-zero/setup.sh` writes.
- US-003: As the maintainer, I remove the `validate-telemetry-schema` CI job, so that CI guards nothing the product no longer has.

## Waves

One wave. The run has three user stories.

## Target Architecture

### Components

- `planifest-zero`: the shipped framework. This run changes only its tests README.
- Repo-level files outside any component: `.github/workflows/planifest.yml`, `refresh-planifest-zero-dir.ps1`, `planifest-overrides/`, and `plan/state/`.

### Data Ownership

No component owns data.

### Integration Points

- GitHub Actions runs the workflow.
- `planifest-zero/setup.sh` reads and writes `plan/state/claude-code.md`.

## Stack

| Layer | Choice |
|-------|--------|
| Language | Bash, PowerShell, and Node.js scripts |
| Runtime | Node.js 18 or later |
| Framework | none |
| Database | none |
| ORM | none |
| IaC | none |
| Cloud | none |
| Compute | local developer machine |
| CI | GitHub Actions |
| Build target | none |

## Scope Boundaries

### In Scope

- Delete `planifest-framework/` with `git rm`.
- Move the setup record to `plan/state/claude-code.md` with no retired flag and no `backendUrl`. Remove `planifest-overrides/setup-config/`.
- Remove the `validate-telemetry-schema` job.
- Remove the retired flag from `refresh-planifest-zero-dir.ps1`.
- Update the two live references to the old folder name.
- Point `core.hooksPath` at `planifest-zero/hooks` before the deletion.
- Reword `custom-004-p9-push-and-raise-pr.md` to name the ship phase.
- Add suites that prove each change.

### Out of Scope

- Running the Bash suites in CI. Backlog 0000108 covers it.
- Changes to the five-phase pipeline in `planifest-zero/`.
- Rewriting historical records under `plan/` or `docs/decisions-index.md`.

### Deferred

- The local reinstall of `.claude/` and `CLAUDE.md` from `planifest-zero/setup.sh`. The human runs it after merging, because setup prunes the old skills that this run uses.

## Non-Functional Requirements

- The full local test run has 0 failing suites, against 1 today.
- CI stays green on every job.

## Constraints and Assumptions

### Constraints

- After the deletion, the remaining phases of this run read templates and scripts from `planifest-zero/` at the same relative path.
- Never commit to `main`, and never merge.

### Assumptions

- No phase from P4 to P9 needs the four files that `planifest-zero/` lacks:
  - `standards/telemetry-standards.md`
  - `templates/defect-report.template.md`
  - `workflows/change-pipeline.md`
  - `workflows/fast-path.md`

## Scenario Paths

Derived at the Scope Lock Challenge. See `build-log.md`.

## Acceptance Criteria

1. `planifest-framework/` is absent from the tree and from `git ls-files`.
2. The rename suite passes cases (a) to (e).
3. `plan/state/claude-code.md` exists, names `claude-code`, and has an empty `flags` array and no `backendUrl`.
4. `planifest-overrides/setup-config/` is absent.
5. `.github/workflows/planifest.yml` has no `validate-telemetry-schema` job and no `PLANIFEST_TELEMETRY_URL`.
6. `refresh-planifest-zero-dir.ps1` passes no retired flag.
7. A run of `planifest-zero/setup.sh claude-code` in a copy of the repo leaves `plan/state/claude-code.md` with no retired flag.
8. `git config core.hooksPath` prints `planifest-zero/hooks`.
9. `custom-004-p9-push-and-raise-pr.md` names the ship phase and no P9.
10. The full local run reports 0 failing suites, and CI is green on every job.
