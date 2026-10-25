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
- The question and these rules live in `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-run-speed.md`. Design Confirmation and the Pack Index point to it. (Deviation, 2026-10-25: `SKILL.md` has a size budget and keeps its base lines word for word, per 0000151 req-011.)

## Acceptance Criteria
- [ ] AC-1: Orchestrator asks and records the speed
  - Given the orchestrator skill and its run-speed reference file
  - When a test reads Design Confirmation and the reference file
  - Then Design Confirmation names `plan/.run-speed`
  - And the reference file holds the question with `Standard` and `Fast` options and the `Run speed:` line
- [ ] AC-2: Missing, unknown, and roadmap values
  - Given the orchestrator skill, the roadmap standards, and the roadmap template
  - When a test reads them
  - Then the reference file says a missing or unknown value counts as `standard`
  - And R-C Run and the template name the `**Speed:**` field
- [ ] AC-3: Ship clears the speed file
  - Given the ship skill and the orchestrator skill
  - When a test reads ship Step 8 and the reference file's cleanup list
  - Then Step 8 names `plan/.run-speed`, and the list names both orchestrator cleanup steps and Step 8

## Dependencies
- None
