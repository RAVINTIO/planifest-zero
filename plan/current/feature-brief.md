---
title: "Feature Brief - setup JSON checks and park"
summary: "Both setup scripts reject valid JSON they cannot use, and a new park command shelves a part-finished feature on its branch."
status: "approved"
version: "0.1.0"
---
# Feature Brief - setup JSON checks and park

**Feature ID:** 0000040-setup-json-checks-and-park

## Business Goal

Setup must never report enforcement hooks as installed when it left `settings.json` unchanged. Today an array in `settings.json` does exactly that, and other valid JSON values print a node stack trace. Separately, a human who wants to shelve a part-finished feature has to revert commits and clear sentinels by hand. A park command does this in one step and keeps the work for later.

Folds in backlog entries 0000120, 0000121, 0000122, and 0000101.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| setup.sh shape check (0000121) | As a person running `setup.sh`, I get one fixed error line and exit 1 when `settings.json` is valid JSON but not a settings object, so that I never believe the hooks are installed when they are not. | must-have | 1 |
| setup.ps1 shape check (0000120) | As a person running `setup.ps1`, I get the same fixed error line when `settings.json` is valid JSON that PowerShell cannot read as a settings object, so that the message names the real fault instead of calling valid JSON invalid. | must-have | 1 |
| Linear JSON check (0000122) | As a person running `setup.ps1`, I get a prompt failure on very deep nesting, so that the strict JSON check never slows with the square of the depth. | should-have | 1 |
| Park a feature (0000101) | As a human on the loop, I say "park" and the orchestrator shelves the feature on its branch, files a backlog entry, and returns me to `main`, so that I can start other work without losing or hand-reverting progress. | must-have | 1 |
| Resume or discard a parked feature (0000101) | As a human on the loop, I pick up a parked entry at a later P1 and either resume it from its recorded phase or discard its branch, so that parked work is never lost or left behind silently. | must-have | 1 |

## Waves

One wave. The release holds 7 of 8 points.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | Framework skills, hooks, templates, setup scripts, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.claude/settings.json` (hook wiring) | planifest-zero setup | none |
| `plan/` working state | planifest-zero orchestrator | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| orchestrator park command | git and `gh` | CLI | Commit, push, and `gh pr create` on a chore branch. Never merges, never commits to `main`. |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript (Node), Markdown skills |
| Runtime | Node, Bash, PowerShell 5.1 and 7 |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | shell and node test scripts under `planifest-zero/tests/` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- One fixed error line, shared by both setup scripts, for valid JSON that setup cannot use. Exit 1 and leave the file unchanged.
- `setup.sh` rejects a top level that is not a plain object, and a `hooks` value that is present and not a plain object.
- `setup.ps1` rejects the same cases, plus case-duplicate keys and nesting deeper than 1024.
- `Test-JsonText` tracks depth with a counter and a `Stack[char]`, and stops at depth 1024.
- A park command in the orchestrator skill, with a park record template.
- Resume detection and backlog pickup that recognise a parked feature.

### Out of Scope
- `setup.sh` rejecting case-duplicate keys. Node reads them, so the scripts differ here by design.
- Reverting commits on `main`. Unmerged feature work never reaches `main`.
- Parking more than one feature at a time on one working tree.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Performance | `Test-JsonText` cost grows linearly with input length. Depth over 1024 fails before the parse. | Regression test with nesting of 100,000 levels finishes in under 5 seconds |
| Security | No error path prints `settings.json` content or a parser message (0000033 req-004). | Tests assert the exact stderr line |

## Constraints and Assumptions

### Constraints
- 0000039 ADR-002 stands: invalid JSON keeps its existing message.
- Park never merges, never commits to `main`, and never force-pushes.

### Assumptions
- `gh` is available and authenticated when park runs. If not, park reports the error and stops with the branch intact.

## Scenario Paths

Filled at the Scope Lock Challenge.

## Acceptance Criteria

- [ ] `setup.sh` given `["x"]`, `null`, `"text"`, or `{"hooks":"text"}` prints `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.`, exits 1, and leaves the file unchanged.
- [ ] `setup.ps1` prints the same line and exits 1 for those inputs and for `{"a":1,"A":2}`.
- [ ] `setup.ps1` given nesting deeper than 1024 prints the same line and exits 1 within 5 seconds.
- [ ] Neither script prints file content or a parser message on any of these paths.
- [ ] Park writes `plan/current/park.md` on the feature branch, commits, and pushes it.
- [ ] Park files a backlog entry naming the branch through a chore PR, and leaves the working tree on `main`.
- [ ] At P1 backlog pickup, pull-in of a parked entry checks out its branch and resumes from `park.md`.
- [ ] At P1 backlog pickup, discard of a parked entry deletes its branch only after the human confirms.
