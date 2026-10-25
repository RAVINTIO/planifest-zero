---
title: "Requirement: REQ-004 - governance-report-at-ship"
summary: "Ship runs the script on the archive folder and adds its section to the build report and the PR description."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - governance-report-at-ship

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Source:** US-004 (backlog 0000100)
**Priority:** must-have

## User Story

As a PR reviewer, I read the metrics and any breach in the build report and the PR description, so that I see how the workflow ran.

## Functional Requirements
- Ship Step 5 runs `node ravintio-zero/scripts/workflow-metrics.mjs {archive-folder}` and appends its output to `build-report.md`.
- Ship Step 9 copies the same section into the PR body, in both run modes and for both PR options.
- If the script exits non-zero, ship writes `Workflow governance: not measured ({reason})` in both places and carries on.
- A breach never stops ship, in either run mode.

## Acceptance Criteria
- [ ] AC-1: Build report carries the section
  - Given the ship skill
  - When a test reads Step 5
  - Then it names `workflow-metrics.mjs` and `build-report.md`
- [ ] AC-2: PR body carries the section
  - Given the ship skill
  - When a test reads Step 9
  - Then it names the `## Workflow governance` section
- [ ] AC-3: Ship never blocks on the gate
  - Given the ship skill
  - When a test reads Steps 5 and 9
  - Then they hold `not measured` and say a breach does not stop ship

## Dependencies
- REQ-001 and REQ-002 supply the script.
