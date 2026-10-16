---
title: "Feature Brief - setup hardening"
summary: "The business case, scope, and product requirements for the feature."
status: "draft"
version: "0.1.0"
---
# Feature Brief - setup hardening

**Feature ID:** 0000034-setup-hardening

> Drafted by the orchestrator from backlog entries 0000088, 0000091, 0000092, 0000096, and 0000102, which the human chose for this release on 2026-10-16.

## Business Goal

Make `planifest-zero/setup.sh` and `setup.ps1` safe to re-run on an upgraded project. Today a refresh fails on any project set up before 0000033, because setup exits 1 on retired flags. A setup run that stops partway can also leave `.claude/settings.json` truncated. This release fixes both, aligns the tool-name check across the two scripts, and clears two small housekeeping items.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Retired flags (0000092) | As a user refreshing an install made before 0000033, I run setup with my recorded flags, so that setup warns about each retired flag, skips it, and completes. | must-have | 1 |
| Exact tool name (0000088) | As a maintainer, I pass a tool name to `setup.sh`, so that only an exact match to a valid tool runs, the same as `setup.ps1`. | must-have | 1 |
| Atomic settings writes (0000091) | As a user, I run setup, so that an interrupted write never leaves `.claude/settings.json` truncated. | must-have | 1 |
| Missing node warning (0000091) | As a user without `node` on the `PATH`, I run `setup.sh`, so that it tells me it skipped the settings cleanup. | should-have | 1 |
| Stray marker (0000096) | As a maintainer, I start a pipeline run, so that P0 raises no false stale-marker flag from the root `.feature-id`. | should-have | 1 |
| Human request source (0000102) | As a human filing a backlog idea, I set the deferral source to `human request`, so that the entry matches the template. | should-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All six | All acceptance criteria pass and P4 is green apart from overrides already granted |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| `planifest-zero` | component-pack | existing | The Planifest product: setup scripts, hooks, skills, templates |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| None | n/a | n/a |

`planifest-zero` writes `.claude/settings.json` and the flags marker in the target project, as it already does. No new data.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `planifest-refresh-setup` skill | `setup.sh` / `setup.ps1` | CLI | Replays recorded flags. The contract gains: retired flags warn and continue |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript (inline `node -e` for JSON) |
| Runtime | Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+ |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test suites run by `planifest-zero/tests/run-tests.sh` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Both setup scripts accept retired flags with one warning per flag and continue. Retired set: `--structured-telemetry-mcp`, `--backend-url <url>`, `--context-mode-mcp`, `--include-full-skill-library`.
- `setup.sh` validates the tool name by exact match.
- Every `settings.json` write in both scripts goes to a temporary file in the same folder, then renames over the original.
- `setup.sh` prints one warning when `node` is missing and it skips the settings cleanup.
- Delete the root `.feature-id`.
- Add `human request` to the backlog template's deferral sources.

### Out of Scope
- `planifest-framework/` (0000033 ADR-001).
- Changes to `planifest-refresh-setup` (human decision on 0000092).
- Other file writes, such as the boot file and the flags marker.
- PowerShell parity gaps in 0000090 and 0000094.

### Deferred
- A `pwsh` test runner. Without one, PowerShell changes get static checks only, as in 0000033.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Compatibility | A setup run with only current flags gives byte-identical `settings.json` output to 0.4.0 | Suite compares output before and after |
| Robustness | 0 truncated `settings.json` files when a write fails | Suite forces a failed write and checks the original survives |
| Security | No new shell-injection path. Retired flag values are never run or written | P5 review |

## Constraints and Assumptions

### Constraints
- 0000030 ADR-001 rejected retired flags as silent no-ops. This feature makes them loud no-ops, which needs a new ADR.
- No `pwsh` on the dev machine or in CI.

### Assumptions
- Old markers list retired flags as plain strings, with `backendUrl` in a separate field.
- A rename within one folder is atomic on the file systems Planifest supports.

## Scenario Paths

**Happy path:**

> To be drafted at the Scope Lock Challenge.

**First-run path:**

> To be drafted at the Scope Lock Challenge.

**Error / sad path:**

> To be drafted at the Scope Lock Challenge.

**Cross-session continuity:**

> To be drafted at the Scope Lock Challenge.

## Acceptance Criteria

- [ ] `setup.sh claude-code --structured-telemetry-mcp --backend-url http://x` exits 0 and prints one warning per retired flag.
- [ ] `setup.sh claude` and `setup.sh '.*'` exit 1 with `Unknown tool`.
- [ ] A forced failed write leaves the original `settings.json` intact in both scripts.
