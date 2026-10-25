---
title: "Feature Brief - subagent acceleration"
summary: "One backlog entry: a fast run speed that dispatches each phase's parallel work units in one batch, with timing in the build log."
status: "approved"
version: "0.17.0"
---
# Feature Brief - subagent acceleration

**Feature ID:** 0000172-subagent-acceleration

## Business Goal

Each phase decides for itself when to split work across subagents. So a run with many small, independent units still moves slowly. This release adds a `fast` run speed. In it, each phase dispatches a listed set of parallel work units in one batch. Phases still run in order and every gate stays. The build log records agent count and wall-clock time per phase, so the build assessment can measure the gain.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Run speed setting (0000110) | As a human on the loop, I choose a `fast` run speed at discovery, so that a run with many independent units finishes sooner. | must-have | 1 |
| Fast batches per phase (0000110) | As a phase agent in a `fast` run, I dispatch my phase's listed parallel work units in one batch, so that independent work does not wait in line. Phases still run in order and every gate stays in place. | must-have | 1 |
| Phase timing in the build log (0000110) | As a maintainer, I read the agent count and wall-clock time of each phase in the build log and the build report, so that I can measure the gain. | must-have | 1 |

## Acceptance criteria

1. In a `fast` run, each phase dispatches its listed parallel work units in one batch.
2. Phases still run in order, and every gate and exception stop stays in place.
3. The build log records the subagent count and wall-clock time for each phase.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The drop-in pipeline pack: skills, hooks, setup, templates, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | | |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| orchestrator | phase skills | `plan/.run-speed` file | one line, `fast` or `standard` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash |
| Testing | Shell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A `plan/.run-speed` file with `fast` or `standard`, asked at discovery.
- A fast-batch list in each phase skill and the dispatch standards.
- Wall-clock time per phase in the build-log template and the build report.

### Out of Scope
- Overlapping phases or running a requirement through spec, code, and validation as its own stream. The wanted outcome keeps phases in order.
- A `fast` value in `plan/.run-mode`.
- Other backlog entries.

### Deferred
- Nothing deferred.
