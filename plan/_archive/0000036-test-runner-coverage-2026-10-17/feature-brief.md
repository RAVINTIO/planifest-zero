---
title: "Feature Brief - test runner coverage"
summary: "The business case, scope, and product requirements for the feature."
status: "approved"
version: "0.1.0"
---
# Feature Brief - test runner coverage

**Feature ID:** 0000036-test-runner-coverage

> Drafted by the orchestrator from backlog entry 0000084, which the human chose on 2026-10-17 with "Go".

## Business Goal

Make the test runner say what it didn't run. Today `run-tests.sh` skips any file that misses its glob without a word, and no PowerShell suite can run at all. Features 0000034 and 0000035 changed six `setup.ps1` functions that no test executes. P5 found a Medium fault in one of them by reading the code. This release adds PowerShell suites, runs them in CI on Windows PowerShell 5.1 and PowerShell 7, and makes every gap in discovery fail the run.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Loud discovery | As a maintainer, I add a test file that misses the naming rule, so that the run fails and names the file. | must-have | 1 |
| Manifest both ways | As a maintainer, I promote a regression suite, so that a suite on disk with no manifest entry fails the run. | should-have | 1 |
| PowerShell suites | As a maintainer, I add a `test-*.ps1` suite, so that the runner runs it, or says loudly that it skipped it. | must-have | 1 |
| setup.ps1 runtime tests | As a Windows user, I rely on `setup.ps1`, so that its main behaviours run under test on both PowerShell versions. | must-have | 1 |
| CI on Windows | As a reviewer, I open a PR, so that CI runs the PowerShell suites on Windows PowerShell 5.1 and PowerShell 7. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All five | All acceptance criteria pass, and the new CI job is green on the PR |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| `planifest-zero` | component-pack | existing | The Planifest product, including `tests/` |

The CI workflow at `.github/workflows/planifest.yml` belongs to this repo, not the product.

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| None | n/a | n/a |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell |
| Runtime | Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+ |
| Framework | none (plain assert helpers, no Pester) |
| Database | none |
| ORM | none |
| IaC | none |
| Cloud | none |
| Compute | local, GitHub Actions runners |
| CI | GitHub Actions |
| Build target | local |

## Acceptance Criteria

1. A stray file in `tests/` or `tests/regression/` makes `run-tests.sh` exit 1 and name the file.
2. A regression suite with no manifest entry makes the run fail.
3. `run-tests.sh` runs every `test-*.ps1` when `pwsh` exists, and prints a skip line with the count when it doesn't.
4. PowerShell suites exercise `setup.ps1` for each 0000035 behaviour.
5. A CI job runs the PowerShell suites on `windows-latest` under both hosts, and passes.

## Scenario Paths

Left empty. The orchestrator drafts them at the Scope Lock Challenge.
