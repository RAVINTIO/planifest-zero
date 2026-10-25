---
title: "Requirement: REQ-002 - thresholds-and-report-only-gate"
summary: "A pack standard holds a threshold per metric, and the script marks each metric over its threshold as a breach without blocking."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - thresholds-and-report-only-gate

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Source:** US-002 (backlog 0000100)
**Priority:** must-have

## User Story

As a maintainer, I set a threshold for each metric in the pack, so that a run that breaches one stands out.

## Functional Requirements
- `ravintio-zero/standards/workflow-governance-standards.md` defines the four metrics and their marker lines.
- The standard holds a `## Thresholds` table with a `Key` column and a `Threshold` column. The keys are `rework-per-requirement`, `blocked-stops`, `design-changes`, and `gate-corrections`.
- The default thresholds are 2, 1, 1, and 2.
- A metric breaches when its value is greater than its threshold.
- The section shows each metric with its value, threshold, and result (`ok` or `breach`). It ends with a line that counts breaches and says the gate does not block.
- The script exits 0 whenever it reads the build log and the thresholds, with or without a breach.
- If the thresholds table is missing a key or holds a value that is not a whole number, the script exits 1 and names the key on stderr.
- `--standard {path}` points the script at another standard file, for tests.

## Acceptance Criteria
- [ ] AC-1: Reports a breach without blocking
  - Given a run folder with three `Blocked:` markers and the default thresholds
  - When the script runs
  - Then the `Blocked:` stops row reads `breach`
  - And the script exits 0
- [ ] AC-2: Reads thresholds from the standard
  - Given a standard file whose `blocked-stops` threshold is 5
  - When the script runs on the same folder with `--standard`
  - Then the `Blocked:` stops row reads `ok`
- [ ] AC-3: Rejects a bad thresholds table
  - Given a standard file with no `gate-corrections` row
  - When the script runs with `--standard`
  - Then it exits 1 and names `gate-corrections` on stderr

## Dependencies
- REQ-001 supplies the counts.
