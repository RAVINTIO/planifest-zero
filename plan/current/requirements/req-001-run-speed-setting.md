---
title: "Requirement: REQ-001 - run-speed-setting"
summary: "The orchestrator asks for a run speed and writes plan/.run-speed, and every later step reads it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - run-speed-setting

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Source:** US-001 (backlog 0000110)
**Priority:** must-have

## User Story

As a human on the loop, I choose a `fast` run speed at discovery, so that a run with many independent units finishes sooner.

## Functional Requirements
- After the run-mode question, the orchestrator asks a run-speed question with two options, `standard` and `fast` (ADR-002).
- The orchestrator writes the answer to `plan/.run-speed`. It appends `Run speed: {fast | standard} ({ISO-8601 timestamp})` to the build log and commits both with the discovery commit.
- A missing `plan/.run-speed` counts as `standard`. A value other than `fast` or `standard` counts as `standard`, and the build log names the value.
- On resume, the orchestrator reads `plan/.run-speed` and asks no question.
- A roadmap step takes the speed from the roadmap's `**Speed:**` field without a question. If the field is absent, the step runs at `standard`.
- `plan/.run-mode` keeps its two values. The speed never goes into it.
- The ship phase deletes `plan/.run-speed` at Step 8 with the other sentinels. The stale run-mode check and the interrupted-ship cleanup delete it too.

## Acceptance Criteria
- [ ] AC-1: Orchestrator asks and records the speed
  - Given the orchestrator skill
  - When a test reads its Design Confirmation section
  - Then it holds a run-speed question with `Standard` and `Fast` options
  - And it names `plan/.run-speed` and the `Run speed:` build-log line
- [ ] AC-2: Missing, unknown, and roadmap values
  - Given the orchestrator skill, the roadmap standards, and the roadmap template
  - When a test reads them
  - Then the orchestrator says a missing or unknown value counts as `standard`
  - And R-C Run and the template name the `**Speed:**` field
- [ ] AC-3: Ship clears the speed file
  - Given the ship skill and the orchestrator skill
  - When a test reads ship Step 8 and the cleanup rules
  - Then each names `plan/.run-speed` for deletion

## Dependencies
- None
