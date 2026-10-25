---
title: "Feature Brief - explain strict mode"
summary: "One backlog entry: explain strict mode and the acknowledgement file, and link the docs to that explanation."
status: "approved"
version: "0.18.1"
---
# Feature Brief - explain strict mode

**Feature ID:** 0000185-explain-strict-mode

## Business Goal

Strict mode writes `plan/.orchestrator-ack`, but no doc says what the file holds or why it has that name. "Ack" is networking jargon, so few readers expect it as a file name. The getting-started link for strict mode lands on the sentinel section, which does not mention strict mode. This release rewrites the strict mode section in `project-operations.md` and points the links at it.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Strict mode section (0000184) | As a pack user, I read one section in `project-operations.md` and learn what strict mode does and what `plan/.orchestrator-ack` holds, so that the banner and the file make sense. | must-have | 1 |
| Links to the section (0000184) | As a pack user, I follow the strict mode link from `getting-started.md` or `README.md` and land on that section, so that I find it without searching. | must-have | 1 |

## Acceptance criteria

1. The strict mode section in `project-operations.md` names `plan/.orchestrator-strict`, `plan/.orchestrator-ack`, and the `--strict-orchestrator` flag.
2. The section says what `plan/.orchestrator-ack` holds, why it has that name, and what to do in a roadmap run.
3. The `getting-started.md` strict mode row and the `README.md` `--strict-orchestrator` row link to `project-operations.md#strict-orchestrator-mode`.
4. A test checks criteria 1 and 3.

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
| none | | | |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash |
| Testing | Shell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- The strict mode section, two links, glossary terms, and one test.

### Out of Scope
- Hook, skill, or script changes.
- The roadmap driver case. Backlog entry 0000182 holds it.
- Other backlog entries.

### Deferred
- Nothing deferred.
