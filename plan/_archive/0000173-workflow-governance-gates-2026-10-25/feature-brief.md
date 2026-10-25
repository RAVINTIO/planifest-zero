---
title: "Feature Brief - workflow governance gates"
summary: "One backlog entry: derive four workflow metrics at ship and report threshold breaches without blocking."
status: "approved"
version: "0.18.0"
---
# Feature Brief - workflow governance gates

**Feature ID:** 0000173-workflow-governance-gates

## Business Goal

The pipeline checks the product it builds, but nothing measures how well the workflow ran. Without a measure, a change to the skills cannot show that it improved quality. This release derives four workflow metrics at ship from the build log and the loop-state files. A governance gate compares each metric against a threshold in the pack. It reports any breach in the build assessment and the PR description. It never blocks.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Workflow metrics script (0000100) | As a maintainer, I run one script on a run's folder and get four workflow metrics, so that I can compare runs. | must-have | 1 |
| Thresholds and a report-only gate (0000100) | As a maintainer, I set a threshold for each metric in the pack, so that a run that breaches one stands out. | must-have | 1 |
| Metric markers in the build log (0000100) | As a phase agent, I write one fixed line for each rework loop, design change, and gate correction, so that the script can count them. | must-have | 1 |
| Governance report at ship (0000100) | As a PR reviewer, I read the metrics and any breach in the build report and the PR description, so that I see how the workflow ran. | must-have | 1 |

## Acceptance criteria

1. At ship, a script derives four metrics from the build log and the loop-state files: rework loops per requirement, `Blocked:` stops, mid-pipeline design changes, and human corrections at gates.
2. The pack holds a threshold for each metric. The gate compares each metric against it.
3. The build report and the PR description show each metric and any breach.
4. The gate never blocks ship, in either run mode.

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
| phase skills | metrics script | build-log marker lines | `Rework:`, `Blocked:`, `Requirement change:`, `Gate revised:` |
| ship skill | metrics script | `node` call | folder path in, Markdown section out |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Node.js (built-in modules only), Bash |
| Testing | Shell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A metrics script, a thresholds table in a pack standard, the marker lines, and the ship report.

### Out of Scope
- The evaluation suite that runs skills against fixed briefs. Backlog entry 0000174 holds it.
- A blocking gate.
- Metrics across runs, such as trends over the archive.
- Other backlog entries.

### Deferred
- Nothing deferred.
