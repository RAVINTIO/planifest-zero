---
title: "Feature Brief - improvement loops"
summary: "Add a bounded improvement loop after GREEN in the implement phase."
status: "approved"
version: "0.1.0"
---
# Feature Brief - improvement loops

**Feature ID:** 0000202-improvement-loops

## Business Goal

The TDD loop stops at the first green result and the refactor step often reports no change. Engineers improve a working solution once the tests show what the code needs. A bounded improvement loop gives the pipeline the same step. Source: backlog entry 0000179.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Improvement loop | As the human on the loop, I get up to 2 improvement cycles per requirement after GREEN, each recorded in the build log, so that a working solution is simplified before it ships. | must-have | 1 |
| Cycle markers | As the human on the loop, I read one `Improve:` marker per cycle that names the finding, the change, and the suite result, so that I can measure the gain. | must-have | 1 |

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
- An improvement loop in the implement skill's TDD inner loop, with a cap of 2 cycles and an early stop.
- A fresh-context reviewer brief, and an apply mode in the refactor skill.
- The `Improve:` marker in the workflow governance standard.
- The fast batch, the docs that name the loop, and tests.

### Out of Scope
- An improvement pass in P3. Validate keeps its failure loops.
- A threshold or metric for improvement cycles in `workflow-metrics.mjs`.
- A loop toggle in `loop-toggles.yml`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Loop bound | At most 2 cycles per requirement | A test reads the cap in the implement skill |

## Constraints and Assumptions

### Constraints
- Node built-ins only. No new dependency. No schema change.

### Assumptions
- The refactor skill's hard limits stay in force during an improvement cycle.

## Scenario Paths

**Happy path:** After GREEN and refactor, a fresh reviewer names a simpler design, the refactor skill applies it, the suite passes, and the build log records the cycle.

> Self-confirmed (initiative).

**First-run path:** The first requirement of a run starts with no cycle count and gets up to 2 cycles.

> Self-confirmed (initiative).

**Error / sad path:** If the suite fails after a change, the change is reverted and the cycle records no change.

> Self-confirmed (initiative).

**Cross-session continuity:** Each cycle writes its marker to the tracked build log, so a resumed run counts the cycles done.

> Self-confirmed (initiative).

## Acceptance Criteria

- [ ] After GREEN, the build log records up to 2 improvement cycles per requirement.
- [ ] Each cycle names the reviewer's finding and the change made, and the suite passes after it.
- [ ] A cycle stops early when the reviewer finds nothing worth changing.
