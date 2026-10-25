---
title: "Requirement: REQ-001 - workflow-metrics-script"
summary: "A Node script derives four workflow metrics from a run folder's build log and loop-state files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - workflow-metrics-script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Source:** US-001 (backlog 0000100)
**Priority:** must-have

## User Story

As a maintainer, I run one script on a run's folder and get four workflow metrics, so that I can compare runs.

## Functional Requirements
- `node ravintio-zero/scripts/workflow-metrics.mjs {run-folder}` reads `{run-folder}/build-log.md` and every `{run-folder}/loop-state-*.md`.
- The script counts marker lines. A marker counts only when it starts a line or a list item, outside fenced code blocks.
- Rework loops per requirement: the count of `Rework: REQ-{nnn}:` markers per requirement id. The report shows the highest count and the requirement that holds it.
- `Blocked:` stops: the count of `Blocked:` markers.
- Mid-pipeline design changes: the count of `Requirement change:` markers.
- Human corrections at gates: the count of `Gate revised:` markers.
- The script prints a Markdown `## Workflow governance` section to stdout. It prints counts and requirement ids only, never marker text.
- The script uses Node built-in modules only and writes no file.
- If the build log is missing or unreadable, the script prints one line to stderr naming the path and exits 1.

## Acceptance Criteria
- [ ] AC-1: Counts each marker
  - Given a run folder whose build log and loop-state file hold known markers
  - When the script runs on the folder
  - Then the section shows the expected count for each of the four metrics
  - And the rework row names the requirement with the highest count
- [ ] AC-2: Ignores prose and fenced code
  - Given a build log that mentions `Blocked:` mid-sentence and inside a fenced code block
  - When the script runs
  - Then neither mention counts
- [ ] AC-3: Fails cleanly without a build log
  - Given a folder with no `build-log.md`
  - When the script runs
  - Then it exits 1 and names the missing path on stderr

## Dependencies
- REQ-002 supplies the thresholds the section compares against.

## Deviations
- The governance standard lists the marker forms as bullets, not in the metrics table. The `|` characters in the `Requirement change:` form would break a table cell.
- If two requirements tie on the highest rework count, the report names the lower requirement id.
- An unreadable standard file exits 1 with a stderr line naming the path.
