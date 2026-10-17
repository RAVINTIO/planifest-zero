---
title: "Feature Brief - setup-hook-filter-fixes"
summary: "The business case, scope, and product requirements for the feature."
status: "approved"
version: "0.5.1"
---
# Feature Brief - setup-hook-filter-fixes

**Feature ID:** 0000038-setup-hook-filter-fixes

## Business Goal

When setup rewires its hooks, it can delete a user's own hook with no warning. The two setup scripts also remove different entries from the same `settings.json`. This release makes setup remove only Planifest commands, the same way on every platform.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Per-command filter (0000112) | As a user with my own hook in a shared entry, I rerun setup, so that my command survives and only the Planifest commands change. | must-have | 1 |
| `UserPromptSubmit` parity (0000111) | As a user on any platform, I run either setup script, so that both remove the same entries from my `settings.json`. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | The framework, including `setup.sh` and `setup.ps1` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | | |

The setup scripts edit the consumer's `.claude/settings.json`. The consumer owns that file.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript run inline by Node |
| Runtime | Node, Bash, Windows PowerShell 5.1 and PowerShell 7 |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash suites with `tests/helpers/assert.sh`, and `.ps1` suites |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Both scripts filter `PreToolUse` and `UserPromptSubmit` one command at a time.
- An entry keeps its user commands. If no command remains, setup drops the entry.
- `setup.sh` matches `UserPromptSubmit` commands with the path-boundary rule.
- Planted-entry cases in the `.sh` and `.ps1` suites.

### Out of Scope
- The telemetry cleanup, which already filters per command.
- Hook events other than `PreToolUse` and `UserPromptSubmit`.

### Deferred
- A user script with a Planifest basename in another folder, such as `/home/u/tools/gate-write.mjs`. Setup still removes it. A fix needs a narrower match on the hook folder, and old setups wrote several folder shapes. Nothing is blocked.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Correctness | 0 user commands lost across the planted-entry cases | New suites in local and CI runs |
| Parity | Both scripts produce the same entries from the same input | The `.sh` and `.ps1` suites on the same fixtures |
| Regression | 0 failing suites locally and in all CI jobs | `planifest-zero/tests/run-tests.sh` and the GitHub Actions run |

## Constraints and Assumptions

### Constraints
- Settings writes stay atomic (0000034 ADR-002).
- The path-boundary, case-sensitive match stays (0000035 S-004).
- `pwsh` isn't installed locally, so CI proves the `.ps1` suites.

### Assumptions
- No user relies on setup removing their non-Planifest commands.

## Scenario Paths

**Happy path:**

> You rerun setup. In a shared entry, your command stays and only the Planifest commands change. Both scripts give the same `settings.json`.

**First-run path:**

> With no `settings.json`, or with no hook entries yet, setup writes the Planifest entries as it does today.

**Error / sad path:**

> If `settings.json` is invalid JSON or `node` is missing, setup prints its existing warning and leaves the file unchanged. Atomic writes prevent a half-written file.

**Cross-session continuity:**

> Each step is a commit, so an interrupted run resumes from the build log. A second setup run gives the same file as one run.

## Acceptance Criteria

- [ ] An entry with a Planifest command and a user command keeps the user command after either script runs.
- [ ] An entry with only Planifest commands is gone after either script runs, and the fresh Planifest entries appear once.
- [ ] A `UserPromptSubmit` user hook whose path contains `check-design` as a substring survives `setup.sh`.
- [ ] Both scripts give the same result on the same planted fixtures.
- [ ] Rerunning setup twice gives the same `settings.json` as running it once.
