---
title: "Feature Brief - hardening, token efficiency, and faster CI"
summary: "Ten backlog entries: setup and hook hardening, a park security fix, ship order, roadmap driver logging and labels, token efficiency, and faster PowerShell CI."
status: "draft"
version: "0.1.0"
---
# Feature Brief - hardening, token efficiency, and faster CI

**Feature ID:** 0000151-hardening-efficiency-and-ci

## Business Goal

Close the open high and medium backlog items in one release. The release fixes one confirmed security finding and stops sentinels leaking to `main`. Blocked agents get a reason they can act on. The release also cuts the token cost of a run and the length of a CI run.

## Features

The human accepted one release over the 8-point budget (about 19 points). Each entry below becomes one or more requirements.

| Feature | Backlog | User Stories | Priority | Wave |
|---------|---------|-------------|----------|------|
| Park symlink containment | 0000142 | As a maintainer, I park a feature without `park.mjs` writing or deleting files outside the repo, so that a symlink on `main` cannot reach my file system. | must-have | 1 |
| Ship sentinels before the PR | 0000144 | As a maintainer, I merge a ship PR that carries no pipeline sentinels, so that `main` stays clean. | must-have | 1 |
| Hook block reasons on stderr | 0000146 | As an agent blocked by a hook, I see the block reason, so that I fix the cause instead of working round the gate. | must-have | 1 |
| Prune retired hooks | 0000143 | As a maintainer, I rerun setup and lose installed hooks that the pack retired, so that stale hooks stop running. | should-have | 1 |
| Setup write errors | 0000139 | As a maintainer with a read-only `settings.json`, I see one fixed error line, so that I know what to fix without a stack trace. | should-have | 1 |
| Token efficiency | 0000148 | As the person paying for runs, I get the same gates at a lower token cost, so that my allowance lasts longer. | must-have | 1 |
| Roadmap step logs | 0000145 | As a maintainer, I read a per-step log when a roadmap step blocks, so that I can diagnose what the headless session did. | should-have | 1 |
| Roadmap telemetry labels | 0000149 | As a maintainer, I see which roadmap step spent what in telemetry, so that I can attribute cost per step. | should-have | 1 |
| Chart front-loads stops | 0000147 | As a maintainer charting a roadmap, I sharpen vague entries and approve new dependencies up front, so that steps stop less while I am away. | should-have | 1 |
| Faster PowerShell CI | 0000150 | As a contributor, I wait less for CI, so that I get feedback sooner. | should-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All ten | All requirements pass P3 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | Skills, hooks, scripts, templates, standards, and setup for the Planifest Zero pipeline. |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/` working files and sentinels | planifest-zero | none |
| `.claude/settings.json` hook wiring | planifest-zero (setup) | Claude Code reads it |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `roadmap-run.mjs` | `claude -p` | child process | args, env, stdio |
| enforcement hooks | Claude Code | process exit code and stderr | exit 2 blocks, stderr carries the reason |
| GitHub Actions | `run-tests.ps1` | workflow job | exit code |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript (Node ESM), Markdown |
| Runtime | Node, bash, Windows PowerShell 5.1, PowerShell 7 |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | `planifest-zero/tests/` bash and PowerShell suites |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- The ten backlog entries listed under Features, including the six changes in 0000148.
- The second unguarded write in `merge_allowed_tools` (found by the survey for 0000139).
- `ratchet-check.mjs`, which also writes its block reason only to stdout (found by the survey for 0000146).
- Parity in `setup.ps1` wherever `setup.sh` changes.

### Out of Scope
- Backlog 0000095, 0000100, and 0000110.
- New hooks or new pipeline phases.

### Deferred
- Batching PowerShell test cases per process, unless P2 timing shows start-up dominates.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| CI duration | `windows-powershell` wall time below the slower of its two steps today | GitHub Actions run time on the feature PR |
| Test output size | A passing full run in quiet mode prints under 10 KB | `bash run-tests.sh` with quiet mode, piped to `wc -c` |
| Security | No file write or delete outside the repo through a symlink in `park.mjs` | Test with a committed symlink |

## Constraints and Assumptions

### Constraints
- No quality gate gets weaker. Every suite, hook, TDD step, review, and acceptance check keeps its pass criteria.
- Edit sources under `planifest-zero/` only, then rerun setup so `.claude/` matches.

### Assumptions
- Claude Code reads only stderr from a PreToolUse hook that exits 2.
- The `claude` CLI accepts `--model` and `--max-turns` in print mode.

## Scenario Paths

Drafted at the Scope Lock Challenge.

## Acceptance Criteria

Drafted per requirement at P1 from the backlog entries.
