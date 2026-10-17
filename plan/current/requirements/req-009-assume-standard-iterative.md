---
title: "Requirement: req-009 - assume-standard-iterative"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-009 - assume-standard-iterative

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-007, backlog 0000103
**Priority:** must-have

## User Story

As a user in a repo with prior runs, I start P0 without confirming standard-iterative mode, so that P0 skips a question with only one answer.

## Functional Requirements
- In `planifest-zero/skills/planifest-orchestrator/SKILL.md`, step 7 of the P0 steps changes. If standard-iterative is the only signal, the orchestrator assumes it and states it in the P0 briefing without asking.
- The orchestrator still asks in two cases:
  - Signals conflict.
  - The detected mode is external anchor, retrofit, or greenfield.
- The orchestrator records the assumed mode and its signal in `discovery.md`, `design.md`, and the build log, as it does today for a confirmed mode.
- The conflict warning after the Adoption Modes table stays. If the human states a different mode, the orchestrator warns once and asks.
- The design checklist line `Adoption mode confirmed` also accepts an assumed standard-iterative mode.
- A new suite, `planifest-zero/tests/test-0000037-req-009-assume-standard-iterative.sh`, checks the skill text.

## Acceptance Criteria
- [ ] The skill says the orchestrator states standard-iterative mode without asking when it's the only signal (AC 15).
- [ ] The skill still says the orchestrator asks when signals conflict, and for the other three modes (AC 15).
- [ ] The skill still records the mode in `discovery.md`, `design.md`, and the build log.
- [ ] The new suite passes, and every existing suite that reads the orchestrator skill still passes.

## Dependencies
- None. req-009 touches a separate file and runs in parallel in P3.
