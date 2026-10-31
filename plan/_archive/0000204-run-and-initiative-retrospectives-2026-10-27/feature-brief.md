---
title: "Feature Brief - run and initiative retrospectives"
summary: "Add a ravintio-retrospective skill that records a blameless retrospective at the end of each run and each initiative."
status: "approved"
version: "0.1.0"
---
# Feature Brief - run and initiative retrospectives

**Feature ID:** 0000204-run-and-initiative-retrospectives

## Business Goal

The build report at ship lists metrics and a few notes, but no step reviews what went well and what to change. An initiative ends at I-E Delivery with no review across its steps. Lessons stay in build logs that nobody rereads, so the next run repeats the same friction. A blameless retrospective names what to keep and what to change, and files each change as an action. Source: backlog entry 0000178.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Run retrospective | As the human on the loop, I get one blameless retrospective for every shipped run, with at least one thing to keep and one to change, so that the next run does not repeat the same friction. | must-have | 1 |
| Initiative retrospective | As the human on the loop, I get one post-initiative retrospective in the initiative pull request to `main`, so that I review the whole initiative in one place. | must-have | 1 |
| Filed changes | As the human on the loop, I find each change filed as a backlog entry or a repo instruction that names its source retrospective, so that nothing stays unread. | must-have | 1 |
| Retrospective reads | As the human on the loop, I see P0 discovery and initiative charting read the latest retrospectives, so that past lessons shape the next plan. | must-have | 1 |

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
- A `ravintio-retrospective` skill with a run mode and an initiative mode, blameless rules, evidence sources, the questions each mode answers, filing, and the record format.
- A retrospective record template.
- The ship hook: after the build report, ship runs the skill in run mode and the report lists the record.
- The I-E Delivery hook: after the archive and before the PR to `main`, the skill runs in initiative mode and the PR body lists the record.
- The P0 discovery read and the I-A Chart read of the latest retrospectives.
- The docs that count skills, `component.yml`, and tests.

### Out of Scope
- A script that gathers retrospective data or writes records.
- Blocking ship or delivery on a missing retrospective.
- Chart-time decisions from past stops, which backlog entry 0000186 covers.

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
- The skill text budget in test 0000031 and the skill counts in three tests change with the new skill, and the tests state the new values.

## Scenario Paths

**Happy path:** At ship, after the build report, the skill writes one run retrospective with at least one thing to keep and one to change, each change filed as a backlog entry or a repo instruction. At I-E Delivery, after the archive and before the PR, it writes one initiative retrospective that the PR carries.

> Self-confirmed (initiative).

**First-run path:** A repo with no `plan/retrospectives/` folder gets the folder created by the first record. P0 and chart find no earlier record and say so.

> Self-confirmed (initiative).

**Error / sad path:** If an observation blames a person or an agent, the skill rejects it and restates the gap in a process, check, standard, or tool.

> Self-confirmed (initiative).

**Cross-session continuity:** Records live in `plan/retrospectives/`, outside `plan/current/`, so the ship archive step leaves them in place and a later P0 reads them.

> Self-confirmed (initiative).

## Acceptance Criteria

- [ ] Every shipped run has a retrospective in `plan/retrospectives/`, and the build report lists it.
- [ ] Every delivered initiative has a post-initiative retrospective that its pull request to `main` carries.
- [ ] Each record names at least one thing to keep and one to change, and each change links to a filed backlog entry or repo instruction that names the source record.
- [ ] P0 discovery and initiative charting read the latest retrospectives.
