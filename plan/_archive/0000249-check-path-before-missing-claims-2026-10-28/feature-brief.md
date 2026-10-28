---
title: "Feature Brief - PATH check before a missing-program claim"
summary: "Adds two rules to the validate-and-accept skill. A report must prove a program is missing with a PATH search, and a claim that only documentation backs never counts as verified."
status: "approved"
version: "0.1.0"
---
# Feature Brief - PATH check before a missing-program claim

**Feature ID:** 0000249-check-path-before-missing-claims

Source: backlog entry 0000233, pulled in by initiative 0000238 step 11. The entry folder is deleted in this run's commit after the brief.

## Business Goal

In initiative 0000195, step 12 reported that no Codex program was available, though `/opt/homebrew/bin/codex` existed. It also marked a claim `verified` that only the Codex docs backed. Step 14 ran the real program, found the claim false, and had to rise from a patch to a minor bump. The validate-and-accept skill now asks for a `PATH` search before a missing-program report, and it gives docs-only claims their own status.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| PATH check before a missing-program report | As a maintainer, I see the validate-and-accept skill require a `PATH` search with its output before any report says a program is missing, so that a false "missing" claim does not reach the acceptance evidence. | must-have | 1 |
| Unverified (docs only) status | As a maintainer, I see a claim that only documentation backs get the status `unverified (docs only)` and a named line in the report, so that it never reads as `verified`. | must-have | 1 |

## Wanted outcome

- The validate-and-accept skill holds the `command -v` rule and names `/opt/homebrew/bin`.
- The skill defines the `unverified (docs only)` status and says it never counts as `verified`.
- The skill's acceptance evidence rules ask for the `PATH` check output and a list of unverified claims.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the validate-and-accept skill and the test |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

None. The rules are prose in one skill.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash tests already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A `PATH` search rule in `ravintio-validate-and-accept/SKILL.md`, with the common install paths.
- The `unverified (docs only)` status, and the rule that it never counts as `verified`.
- Acceptance evidence rules for the `PATH` check output and a list of unverified claims.
- One test, docs, and the version bump.

### Out of Scope
- A script that runs the `PATH` search for the agent.
- A change to any hook, including `merge-guard` and `gate-write`.
- A change to the verification report or acceptance evidence templates.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.
- The acceptance evidence may reach a public PR. It holds results and counts, so the `PATH` check records the command and a found or not-found result, not raw output.

### Assumptions
- The install paths in the entry cover the hosts that run this pack. Impact if wrong: a program in another folder still reads as missing. The rule says to search the common paths, not only those three.

## Scenario Paths

**Happy path:** A program exists on the `PATH`. The report records `command -v {program}` and its found result, then uses the program.

> The skill's rules lead the agent to run the program, not to claim it is missing.

**Alternative path:** The program is not on the `PATH` but sits in a common install folder.

> The agent finds it by path, records the folder, and runs it from there.

**Error / sad path:** No search finds the program, or a claim has only documentation behind it.

> The report names the program as missing with each command it ran. A docs-only claim gets `unverified (docs only)` and a line in the list of unverified claims.

**Cross-session continuity:** A resumed run reaches P3 again.

> The rules sit in the skill, so a resumed session reads the same rules.

## Acceptance Criteria

- [ ] The validate-and-accept skill holds the `command -v` rule and names `/opt/homebrew/bin`, `/usr/local/bin`, and `~/.local/bin`.
- [ ] The skill defines `unverified (docs only)` and says it never counts as `verified`.
- [ ] The skill's acceptance evidence rules ask for the `PATH` check commands and a list of unverified claims by name.
