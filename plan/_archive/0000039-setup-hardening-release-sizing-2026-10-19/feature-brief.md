---
title: "Feature Brief - setup-hardening-release-sizing"
summary: "The business case, scope, and product requirements for the feature."
status: "approved"
version: "0.6.0"
---
# Feature Brief - setup-hardening-release-sizing

**Feature ID:** 0000039-setup-hardening-release-sizing

## Business Goal

Setup still has three gaps from the 0000038 security review. One leaks `settings.json` content to logs, one runs a stale hook twice, and one cuts deep settings on Windows. Discovery also sizes every release with a fixed 3-story rule that no repo can change. This release closes the setup gaps and replaces the fixed rule with a release-size setting.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Invalid JSON handling (0000113) | As a user with a malformed `settings.json`, I run setup, so that I get one clear error and none of the file's content reaches my logs. | must-have | 1 |
| Single-object `hooks` value (0000114) | As a user whose hook entry holds one `hooks` object, I rerun setup, so that a stale Planifest command goes and each hook runs once. | must-have | 1 |
| JSON depth on PowerShell (0000115) | As a Windows user with deeply nested settings, I run `setup.ps1`, so that no nested value is cut. | must-have | 1 |
| Release-size setting (0000109) | As a maintainer, I set `releaseSize` in `product.yml`, so that discovery fills each release to the budget I chose. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | The framework, including `setup.sh`, `setup.ps1`, the orchestrator skill, and the templates |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | | |

The setup scripts edit the consumer's `.claude/settings.json`. The consumer owns that file. The consumer also owns `product.yml`. The orchestrator only reads `releaseSize` from it.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript run inline by Node, Markdown skills |
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
- Both setup scripts catch invalid JSON in the hook install step. They print one fixed message that names the file, leave the file unchanged, and exit 1.
- Both setup scripts treat a single-object `hooks` value as a one-item array, then apply the per-command filter.
- `setup.ps1` writes `settings.json` with `ConvertTo-Json -Depth 100`.
- An optional `releaseSize` field in `product.yml`: `small`, `medium`, or `large`.
- Size classes at discovery: S (1 to 2 files, 1 point), M (3 to 6 files, 2 points), and L (7 or more files, 4 points).
- Budgets: `small` 4 points, `medium` 8, and `large` 14. The default is `medium`.
- An unknown `releaseSize` value gets a note at discovery and the `medium` budget.
- The orchestrator, the feature brief template, and the feature brief guide point to the setting instead of the 3-story rule.
- Planted-value, single-object, and deep-nesting cases in the `.sh` and `.ps1` suites, and a suite for the sizing text.

### Out of Scope
- The telemetry cleanup's error handling. It already warns and continues.
- Hook events other than `PreToolUse` and `UserPromptSubmit`.
- Tooling that counts files automatically. Discovery estimates the class.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| No content leak | 0 bytes of a planted `settings.json` value in setup's stdout or stderr | Planted-value cases in both suites |
| Parity | Both scripts give the same result on the same input | The `.sh` and `.ps1` suites on shared fixtures |
| Regression | 0 failing suites locally and in all CI jobs | `planifest-zero/tests/run-tests.sh` and the GitHub Actions run |

## Constraints and Assumptions

### Constraints
- Settings writes stay atomic (0000034 ADR-002).
- Setup never logs `settings.json` contents (0000033 req-004).
- The path-boundary, case-sensitive match stays (0000035 S-004).
- `pwsh` isn't installed locally, so CI proves the `.ps1` suites.

### Assumptions
- A file count estimated at discovery is close enough to size a release. The human confirms every fill.

## Scenario Paths

**Happy path:**

> You rerun either setup script on a valid `settings.json`. A single-object `hooks` value that runs a Planifest command is replaced by one fresh entry, and a user object stays. Deep values survive `setup.ps1`. In a later discovery run, the orchestrator reads `releaseSize`, sizes each candidate, and recommends a fill up to the budget.

**First-run path:**

> With no `settings.json`, setup writes the Planifest entries as it does today. With no `releaseSize` in `product.yml`, discovery uses the `medium` budget of 8 points.

**Error / sad path:**

> With invalid JSON, both scripts print one fixed message naming the file, exit 1, and leave the file unchanged. If `releaseSize` holds an unknown value, discovery says so, uses `medium`, and asks you to fix the field.

**Cross-session continuity:**

> Each artifact is a commit, so an interrupted run resumes from the build log. A second setup run gives the same file as one run. The release size lives in `product.yml`, so every session reads the same budget.

## Acceptance Criteria

- [ ] With invalid JSON in `settings.json`, both scripts print one fixed message naming the file, exit 1, and leave the file byte-identical.
- [ ] A value planted in an invalid `settings.json` appears in neither stdout nor stderr of either script.
- [ ] A single-object `hooks` value that runs a Planifest module is gone after either script runs, and the fresh entries appear once.
- [ ] A single-object `hooks` value that runs only a user command stays after either script runs.
- [ ] A value nested 15 levels deep in `settings.json` survives `setup.ps1` unchanged.
- [ ] The orchestrator skill defines `releaseSize`, the three size classes, the three budgets, and the `medium` default.
- [ ] The orchestrator skill tells discovery to note an unknown `releaseSize` value and use `medium`.
- [ ] No skill or template in `planifest-zero/` states the fixed 3-story rule.
