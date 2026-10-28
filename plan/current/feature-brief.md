---
title: "Feature Brief - plan checks count and cap tests"
summary: "Adds a test impact scan to the plan skill so the plan names every test that holds a count, budget, cap or backlog id."
status: "approved"
version: "0.1.0"
---
# Feature Brief - plan checks count and cap tests

**Feature ID:** 0000246-plan-checks-count-and-cap-tests

Source: backlog entry 0000210, pulled in by initiative 0000238 step 8. The entry folder is deleted in this run's commit after the brief.

## Business Goal

Run 0000204 hit three rework loops that a P1 check would have prevented. The plan named none of the tests that hold a skill count, a skill-text budget, a size cap or a backlog entry id. Each rework cost a full test run. The plan phase now names those tests up front.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Test impact scan | As a maintainer, I read the tests that hold counts, budgets, caps and ids in the execution plan, so that a run ends with no rework loop for those causes. | must-have | 1 |

## Wanted outcome

An execution plan that adds a skill, edits the orchestrator skill, or pulls in a backlog entry names each test that holds the count, the budget, the cap, or the entry id. A run that does so ends with no rework loop for those causes.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the plan skill, the execution plan template and the tests |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node 20 scripts already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/`, with PowerShell twins where a suite has one |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A "Test impact scan" section in `ravintio-plan/SKILL.md`.
- A "Test impact" section in the execution plan template.
- A plan test that checks both.
- Docs and version updates.

### Out of Scope
- A script that runs the scan. The plan agent greps by hand.
- Changing any existing count, budget, cap or id test beyond count updates this step's own additions cause.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |
| Plan skill size | The addition stays at 15 lines or fewer | Line count of the new section |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.

### Assumptions
- The four test families in `discovery.md` are the ones the entry means. Impact if wrong: the scan misses a test.

## Scenario Paths

**Happy path:** The plan phase starts, the scan finds the tests for each cause the step triggers, and the execution plan lists them in the unit that edits the file.

> A plan test checks that the skill and the template carry the scan.

**First-run path:** A step that triggers none of the causes records "none found".

> The template section allows "none found".

**Error / sad path:** A grep finds no test for a pulled-in id.

> The plan records "none found" and proceeds.

**Cross-session continuity:** The list sits in `plan/current/execution-plan.md`.

> A resumed P1 reads it back from disk.

## Acceptance Criteria

- [ ] The plan skill has a Test impact scan section naming the four causes.
- [ ] The execution plan template has a Test impact section.
- [ ] A test fails if either is missing.
