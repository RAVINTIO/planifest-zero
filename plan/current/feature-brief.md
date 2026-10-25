---
title: "Feature Brief - faster setup.ps1 tests"
summary: "One backlog entry: cut setup.ps1 time in the PowerShell CI suites by at least half."
status: "approved"
version: "0.15.1"
---
# Feature Brief - faster setup.ps1 tests

**Feature ID:** 0000171-faster-setup-ps1-tests

## Business Goal

The 0000151 timing lines show `setup.ps1` takes about 75% of the PowerShell CI suite time. A profile shows the skill copy takes most of each run, because it makes one cmdlet call per file. This release moves the copy to `System.IO` calls and adds a timing total to the runner.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Fast skill and hook copy (0000159) | As a maintainer, I wait less for the Windows CI jobs, so that a pull request gets its PowerShell result sooner. As a consumer, I run `setup.ps1` and get the same installed files as before, only faster, so that a refresh costs less time. | must-have | 1 |
| CI timing total (0000159) | As a maintainer, I read one timing total per run from `run-tests.ps1`, so that I can check the speed target without summing log lines. | must-have | 1 |

## Acceptance criteria

1. Total `setup.ps1` time across both Windows CI jobs falls from 210 s to under 105 s.
2. A fresh install writes the same skill files with the same bytes as the bundle rules give, under both hosts. Console output is unchanged.
3. `run-tests.ps1` prints the `setup.ps1` total and case count for the run.

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
| `setup-workspace.ps1` | `run-tests.ps1` | timing file named by an environment variable | one millisecond value per line |

## Stack

| Concern | Decision |
|---------|----------|
| Language | PowerShell 5.1 and 7, Bash, Markdown |
| Testing | Shell and PowerShell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `System.IO` copies in `Copy-RavintioSkills` and `Install-EnforcementHooks`.
- A tree parity test under both hosts.
- A `setup.ps1` timing total in `run-tests.ps1`.

### Out of Scope
- `setup.sh` and the Bash suites.
- Sharing one setup run across test cases.
- The workspace copy in the test helper.
- Other backlog entries.

### Deferred
- Nothing deferred.
