---
title: "Feature Brief - blameless postmortems"
summary: "Add a ravintio-postmortem skill that records one blameless postmortem per failed CI run or Blocked stop."
status: "approved"
version: "0.1.0"
---
# Feature Brief - blameless postmortems

**Feature ID:** 0000203-blameless-postmortems

## Business Goal

The pipeline fixes a failure and moves on. Nothing asks why the earlier phases let it through, so the same kind of failure returns. A blameless postmortem finds the gap in a process, check, standard, or tool, and files an action to close it. Source: backlog entry 0000177.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Postmortem skill | As the human on the loop, I get one postmortem record per `Blocked:` stop or CI failure, with a timeline and a 5 whys chain that ends at a process or tool gap, so that the same failure does not return. | must-have | 1 |
| Filed actions | As the human on the loop, I find each corrective, preventive, or detective action filed as a backlog entry or a repo instruction, so that nothing stays in a document no one reads. | must-have | 1 |
| Orchestrator trigger and report | As the human on the loop, I see the orchestrator run the skill after a `Resolved:` line and the build report list the run's postmortems, so that I can find them. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, scripts, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js and Bash |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A `ravintio-postmortem` skill with its trigger, blameless rules, timeline, 5 whys method, actions, filing, and record format.
- A postmortem record template.
- The orchestrator trigger after a `Resolved:` line, before ship, and the skills catalogue row.
- The ship build report line that lists the run's postmortems.
- The docs that count skills, `component.yml`, and tests.

### Out of Scope
- A script that detects triggers or writes records.
- A postmortem for a P3 finding that the run fixed without a stop.
- Blocking ship on a missing postmortem.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | The new skill file stays under 120 lines | A test counts the lines |

## Constraints and Assumptions

### Constraints
- Node built-ins only. No new dependency. No schema change.
- The skill file passes the pack prose and em dash guards.

### Assumptions
- The line budget in test 0000031 allows a thirteenth-to-fourteenth skill file or the test is updated with the skill list.

## Scenario Paths

**Happy path:** After a `Blocked:` stop is resolved, the orchestrator runs the postmortem skill, which writes one record with a timeline, a 5 whys chain ending at a process or tool gap, and a filed action.

> Self-confirmed (initiative).

**First-run path:** A repo with no `plan/postmortems/` folder gets the folder created by the first record.

> Self-confirmed (initiative).

**Error / sad path:** If a 5 whys chain ends at a person or an agent, the skill rejects the chain and asks why again.

> Self-confirmed (initiative).

**Cross-session continuity:** Records live in `plan/postmortems/`, outside `plan/current/`, so the ship archive step leaves them in place.

> Self-confirmed (initiative).

## Acceptance Criteria

- [ ] After a run with a CI failure or a `Blocked:` stop, `plan/postmortems/` holds one record per stop.
- [ ] Each record has a timeline, a 5 whys chain ending at a process or tool gap, and at least one filed action.
- [ ] The build report lists the run's postmortems.
