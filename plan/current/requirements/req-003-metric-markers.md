---
title: "Requirement: REQ-003 - metric-markers"
summary: "Phase skills write one fixed marker line for each rework loop, mid-pipeline change, and gate correction."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - metric-markers

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Source:** US-003 (backlog 0000100)
**Priority:** must-have

## User Story

As a phase agent, I write one fixed line for each rework loop, design change, and gate correction, so that the script can count them.

## Functional Requirements
- The implement skill appends `Rework: REQ-{nnn}: {reason} ({ISO-8601 timestamp})` to the build log for each extra attempt on a requirement after the first.
- The validate-and-accept skill appends the same marker for each self-correct cycle whose fix touches a requirement's code or test.
- The mid-pipeline change reference appends `Requirement change: {cosmetic | additive | contradictory}: {what changed} ({ISO-8601 timestamp})`.
- The orchestrator skill appends `Gate revised: P{N} ({ISO-8601 timestamp}, {what changed})` when the human asks for a change at a gate in a gated run.
- `Blocked:` keeps its form from Exception Stops.
- Each skill points at `ravintio-zero/standards/workflow-governance-standards.md` for the marker forms.

## Acceptance Criteria
- [ ] AC-1: Implement and validate write `Rework:`
  - Given the implement and validate-and-accept skills
  - When a test reads them
  - Then each holds the `Rework: REQ-{nnn}:` marker form and names the governance standard
- [ ] AC-2: Changes and gates have markers
  - Given the mid-pipeline change reference and the orchestrator skill
  - When a test reads them
  - Then the reference holds `Requirement change:` and the orchestrator holds `Gate revised: P{N}`
- [ ] AC-3: The standard lists every marker
  - Given the governance standard
  - When a test reads it
  - Then it lists `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:`

## Dependencies
- REQ-002 defines the standard the skills point at.

## Deviations
- The orchestrator skill holds the short line ``On a gate change, append `Gate revised: P{N}`.`` It leaves out the `({ISO-8601 timestamp}, {what changed})` part. The 0000151 size budget allows 57 more bytes for `SKILL.md` and `CLAUDE.md` together. The full form lives in the governance standard. AC-2 still holds, because the line holds `Gate revised: P{N}`. The same budget leaves no room to name the standard in the orchestrator skill. The standard lists every marker, and the other skills point at it.
