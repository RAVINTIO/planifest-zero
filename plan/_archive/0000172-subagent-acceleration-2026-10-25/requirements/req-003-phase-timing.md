---
title: "Requirement: REQ-003 - phase-timing"
summary: "Each build-log phase block records its end time and wall-clock time, and the build report lists them with agent counts."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - phase-timing

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Source:** US-003 (backlog 0000110)
**Priority:** must-have

## User Story

As a maintainer, I read the agent count and wall-clock time of each phase in the build log and the build report, so that I can measure the gain.

## Functional Requirements
- The build-log template header gains a `Run speed` row.
- Each phase block in the template gains `End` and `Wall clock` rows after `Start`. `Wall clock` is `End` minus `Start` in whole minutes.
- The Summary table gains a `Total wall clock` row.
- The orchestrator fills `End` and `Wall clock` when each phase completes.
- Ship Step 3 fills the summary with agents and wall-clock time per phase.
- Ship Step 5 lists the run speed, then agent count and wall-clock time per phase. A phase with no `End` reads `not recorded`.

## Acceptance Criteria
- [ ] AC-1: Template holds the timing rows
  - Given the build-log template
  - When a test reads it
  - Then it holds `Run speed`, `End`, `Wall clock`, and `Total wall clock` rows
- [ ] AC-2: Orchestrator closes each phase block
  - Given the orchestrator skill
  - When a test reads its Phase Invocation section
  - Then it says to fill `End` and `Wall clock` when a phase completes
- [ ] AC-3: Build report lists timing
  - Given the ship skill
  - When a test reads Steps 3 and 5
  - Then each names wall-clock time, and Step 5 names the run speed and `not recorded`

## Dependencies
- None
