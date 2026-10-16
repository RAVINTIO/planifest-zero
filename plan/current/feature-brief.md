---
title: "Feature Brief - PowerShell setup parity"
summary: "The business case, scope, and product requirements for the feature."
status: "draft"
version: "0.1.0"
---
# Feature Brief - PowerShell setup parity

**Feature ID:** 0000035-powershell-setup-parity

> Drafted by the orchestrator from backlog entries 0000090, 0000094, 0000104, and 0000105. The human asked to keep going after 0000034 on 2026-10-17.

## Business Goal

Make a Windows install match a bash install. Today `setup.ps1` wires four of the six enforcement hooks, so a Windows user gets no ratchet protection and no em-dash guard. `setup.ps1` also fails on Windows PowerShell 5.1, ignores flag case, and rewrites a scalar hook value as an array. Both scripts can also leave a stale temporary file behind after a hard stop.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Six hooks on Windows (0000090) | As a Windows user, I run `setup.ps1`, so that it wires the same six enforcement hooks as `setup.sh`. | must-have | 1 |
| Scalar hook values (0000094) | As a user with a hand-edited `settings.json`, I run `setup.ps1`, so that the legacy cleanup leaves a non-array hook value as it was. | should-have | 1 |
| PowerShell 5.1 (0000105) | As a Windows user on the built-in PowerShell 5.1, I run `setup.ps1`, so that it adds `Agent` to `allowedTools` without a PowerShell 7 feature. | must-have | 1 |
| Flag case (0000105) | As a maintainer, I pass a flag in the wrong case to `setup.ps1`, so that it fails as `setup.sh` does. | should-have | 1 |
| Leftover temporary file (0000104) | As a user, I re-run setup after a hard stop, so that no `settings.json.planifest-tmp` stays behind. | should-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All five | All acceptance criteria pass and P4 is green apart from the known rename-suite failure |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| `planifest-zero` | component-pack | existing | The Planifest product: setup scripts, hooks, skills, templates |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| None | n/a | n/a |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `setup.ps1` | `.claude/settings.json` | file write | The same hook entries `setup.sh` writes |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript (inline `node -e` for JSON) |
| Runtime | Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+ |
| Framework | none |
| Database | none |
| ORM | none |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Acceptance Criteria

1. A static parity suite finds the same six hook modules wired by `setup.sh` and `setup.ps1`, in the same events and matchers.
2. `setup.ps1` holds no `-AsHashtable`, and its flag `switch` is case-sensitive.
3. `Remove-LegacyTelemetryWiring` skips an event value that isn't an array.
4. A `setup.sh` run removes a leftover `.claude/settings.json.planifest-tmp`, even when `node` is missing. `setup.ps1` does the same.
5. Every existing suite still passes, apart from the known rename-suite cases (a) and (b).

## Scenario Paths

Left empty. The orchestrator drafts them at the Scope Lock Challenge.
