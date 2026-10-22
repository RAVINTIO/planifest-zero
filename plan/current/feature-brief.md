---
title: "Feature Brief - setup cleanup and park hardening"
summary: "The telemetry cleanup in both setup scripts skips a settings file it can't read, the non-array warning stops printing hook values, and park cleans up after a failed local commit."
status: "approved"
version: "0.1.0"
---
# Feature Brief - setup cleanup and park hardening

**Feature ID:** 0000041-setup-cleanup-and-park-hardening

## Business Goal

Setup must report one fault once, name the right cause, and never rewrite a file it can't read. Today the telemetry cleanup runs before the 0000040 shape check. In `setup.sh` it prints a wrong warning first. In `setup.ps1` it can turn a top-level array into an object, so the shape check passes and the user's array is gone. Setup must also never print a hook value, which can hold a secret. A failed local commit in park must not carry the entry file back to the feature branch.

Folds in backlog entries 0000127, 0000128, 0000130, and 0000129.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| setup.sh telemetry cleanup skip (0000127) | As a person running `setup.sh`, I see only the shape check line when `settings.json` is not a settings object, so that the output names the real fault once. | must-have | 1 |
| setup.ps1 telemetry cleanup skip (0000128) | As a person running `setup.ps1`, I keep my `settings.json` unchanged when it is not a settings object, so that setup never rewrites a file it rejects. | must-have | 1 |
| Non-array warning without the value (0000130) | As a person running either setup script, I get a warning that names the event and the file but not the old value, so that a secret in a hook command never reaches the terminal or a log. | must-have | 1 |
| Park cleanup on local failure (0000129) | As a human on the loop, I return to a clean feature branch when park's local add or commit fails, so that the parked entry never leaks into the feature branch. | should-have | 1 |

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
| `park.mjs` | git | CLI | On a local add or commit failure, unstage and remove the entry, then return to the feature branch. Never merges, never commits to `main`. |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, JavaScript (Node) |
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
- The telemetry cleanup in both scripts skips without output or a write when `settings.json` fails the 0000040 shape rule. The hook install step then reports the fault.
- The non-array warning in both scripts names the event and the file, and drops the old value.
- `park.mjs` unstages and removes the written entry when a local add or commit fails, before it checks out the feature branch.
- A test for each change. PowerShell tests run in CI.

### Out of Scope
- Retiring the legacy telemetry cleanup (0000095).
- Writing the old non-array value to a backup file. The value is replaced, as today.
- Changes to park's push or `gh` failure paths.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Security | No setup output prints a hook value or `settings.json` content (0000033 req-004). | Tests assert the exact stderr lines |
| Integrity | Setup leaves a rejected `settings.json` byte-identical. | Tests compare file bytes before and after |

## Constraints and Assumptions

### Constraints
- 0000040 ADR-002 stands: the shape check line and exit 1 are unchanged.
- 0000033 ADR-002 stands: the cleanup still runs on every setup run, and still warns and continues on a real failure.
- Park never merges, never commits to `main`, and never force-pushes.

### Assumptions
- A failing `pre-commit` hook in a temporary repo forces a commit failure for the park test.

## Scenario Paths

**Happy path:** Setup on a valid settings object behaves exactly as today. Park on a healthy repo behaves exactly as today.

**First-run path:** With no `settings.json`, the cleanup has nothing to read and setup creates the file as today.

**Error / sad path:** A non-object `settings.json` gets only the shape check line and exit 1, with the file unchanged, in both scripts. A failed park commit leaves the feature branch with no stray entry file and prints the exact git error.

**Cross-session continuity:** Setup writes nothing on a rejected file, so an interrupted run leaves it unchanged. After a failed park commit, the next park attempt starts from a clean feature branch.

## Acceptance Criteria

- [ ] `setup.sh` given `null`, `["x"]`, or `{"hooks":"text"}` prints only the 0000040 shape check line on stderr, exits 1, and leaves the file unchanged.
- [ ] `setup.ps1` given `[{"hooks":{"Stop":[...telemetry entry...]}}]` exits 1 with the shape check line and leaves the file byte-identical.
- [ ] `setup.ps1` given `null` or `{"hooks":"text"}` prints only the shape check line and exits 1.
- [ ] Both scripts, given a non-array `hooks.PreToolUse` that holds a secret string, warn with the event name and the file and never print the secret.
- [ ] When the chore commit fails, `park.mjs` exits non-zero and returns to the feature branch. The working tree then holds neither the entry file nor a staged change.
