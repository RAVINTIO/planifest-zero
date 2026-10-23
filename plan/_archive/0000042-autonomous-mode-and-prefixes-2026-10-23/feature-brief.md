---
title: "Feature Brief - autonomous-mode-and-prefixes"
summary: "Gated and autonomous run modes, phases renumbered P0 to P4 with clear prefixes, and the Planifest Zero name."
status: "approved"
version: "0.9.0"
---
# Feature Brief - autonomous-mode-and-prefixes

**Feature ID:** 0000042-autonomous-mode-and-prefixes

## Business Goal

Planifest Zero has no run mode that takes a confirmed design to a pull request without stopping. Continuous run still stops at acceptance and ship. Its phases run P1 to P5, while Planifest Framework starts at P0, and its message prefixes (`D:`, `PL:`) need a legend. The product also calls itself "Planifest Framework" and "a framework", which confuses it with the separate Planifest Framework product.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Run modes | US-001: As a human on the loop, I choose `autonomous` at the end of P0, so that P1 to P4 run without stopping until the pull request is ready for my review. | must-have | 1 |
| Run modes | US-002: As a human on the loop, I choose `gated`, so that the agent stops for my confirmation at the end of each phase from P1 to P4. | must-have | 1 |
| Phase numbers and prefixes | US-003: As a human on the loop, I read a phase number and name at the start of every message, such as `P2 Implement:`, so that I know where the run is without a legend. | must-have | 1 |
| Product name | US-004: As a reader of `product.yml`, `component.yml`, or the README, I see the name Planifest Zero, so that I never confuse it with Planifest Framework. | must-have | 1 |
| Wording | US-005: As a reader of any Planifest Zero file, I never see Planifest Zero described or named as a framework, so that "framework" refers only to Planifest Framework or to a generic framework. | must-have | 1 |

## Waves

One wave. The human chose one large release of 13 points against a budget of 14.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | Skills, hooks, templates, setup scripts, and tests for the Planifest Zero pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.run-mode` | planifest-zero (orchestrator skill) | phase skills, read only |
| `plan/current/build-log.md` | planifest-zero (orchestrator skill) | phase skills append their own phase block |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| planifest-ship skill | GitHub | `git push`, `gh pr create` | Existing ship behaviour, unchanged |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skills, Bash, PowerShell, JavaScript (Node) |
| Runtime | Node, Bash, PowerShell 5.1 and 7 |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Shell and node test scripts under `planifest-zero/tests/` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Run modes `gated` and `autonomous` replace `interactive` and `continuous`.
- Phases renumber to P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, P4 Ship.
- Message prefixes `P0 Discovery:`, `P1 Plan:`, `P2 Implement:`, `P3 Validate:`, `P4 Ship:`.
- `name: "Planifest Zero"` in `product.yml` and `planifest-zero/component.yml`.
- Every file drops "framework" as a description or identifier of Planifest Zero.

### Out of Scope
- Multi-release autonomy (0000098, 0000099).
- Generic uses of "framework", such as `test-frameworks.md`.
- History under `plan/_archive/` and `plan/changelog/`.
- Migration or compatibility for other installs. This repo is the only install.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Wording | Zero hits for "framework" naming Planifest Zero outside the archive, changelog, and generic uses | A test greps every tracked file against an allowlist of generic uses |
| Phase numbers | Zero phase references outside P0 to P4 in skills, docs, templates, and hooks | A test greps for P5 to P9 |
| Test suite | `run-tests.sh` passes with zero failures | CI on the pull request |

## Constraints and Assumptions

### Constraints
- The human merges every pull request. No mode commits to `main`.
- Schema proposals and 5-attempt escalations stop the run in both modes.

### Assumptions
- No other repo installs Planifest Zero, so renames need no migration.

## Scenario Paths

**Happy path:** The P0 briefing names Planifest Zero 0.9.0 and the phases P0 Discovery to P4 Ship. An autonomous run goes from P1 to P4 and a raised pull request without stopping. A gated run stops after each phase. Every message carries its prefix, and the human merges.

> Confirmed in the build log Scope Lock.

**First-run path:** With no `plan/.run-mode`, P0 asks gated or autonomous and writes the answer. A resume that finds no file or an unknown value asks again, names the value it found, writes the answer, and logs it.

> Confirmed in the build log Scope Lock.

**Error / sad path:** In both modes, 5 failed attempts, a schema change, an unmitigated critical or high security finding, a failed push or PR, or a possible credential stops the run. The `Blocked:` message names the action needed. Work stays committed and pushed, and the run resumes in the same mode.

> Confirmed in the build log Scope Lock.

**Cross-session continuity:** Run mode and phase position live in committed files. A new session reads `plan/.run-mode` and the build log first and restores whichever mode the file holds. It resumes at the last phase with that phase's prefix. A gated run shows its pending gate again.

> Confirmed in the build log Scope Lock.

## Acceptance Criteria

- [ ] The run-mode question offers exactly `gated` and `autonomous`, and `plan/.run-mode` stores one of those values.
- [ ] In `autonomous`, no phase skill stops at the P1, P2, P3, or P4 gate. The run ends with a raised pull request.
- [ ] In `gated`, each of P1 to P4 ends with a confirmation stop.
- [ ] In both modes, an unmitigated critical or high security finding stops the run.
- [ ] A resume with a missing or unknown `plan/.run-mode` asks the run-mode question and names the value it found.
- [ ] Skills, docs, templates, and hooks number the phases P0 to P4 only, and use the five new prefixes.
- [ ] `product.yml` and `planifest-zero/component.yml` say `name: "Planifest Zero"`.
- [ ] No tracked file outside the archive and changelog describes or names Planifest Zero as a framework.
