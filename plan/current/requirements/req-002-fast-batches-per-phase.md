---
title: "Requirement: REQ-002 - fast-batches-per-phase"
summary: "In a fast run, each phase dispatches its listed fast batch units in one message, with phases in order and every gate in place."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - fast-batches-per-phase

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Source:** US-002 (backlog 0000110)
**Priority:** must-have

## User Story

As a phase agent in a `fast` run, I dispatch my phase's listed parallel work units in one batch, so that independent work does not wait in line. Phases still run in order and every gate stays in place.

## Functional Requirements
- `ravintio-zero/standards/agent-dispatch-standards.md` gains a `## Fast batches` section (ADR-003). It states these rules:
  - When `plan/.run-speed` holds `fast`, a phase dispatches every unit of its fast batch in one message, one `Agent` call per unit.
  - Units in one batch write disjoint files.
  - The Cannot parallelise table still applies.
  - Phases run in order. No unit of phase N+1 starts before phase N ends.
  - Gates, exception stops, and progress markers stay as they are.
  - At `standard`, each phase keeps its existing parallelism rules.
- The plan, implement, validate-and-accept, and ship skills each gain a `### Fast batch` subsection that lists their units in order.
- The orchestrator's Phase Invocation reads `plan/.run-speed` at each transition and names the phase's fast batch.

## Acceptance Criteria
- [ ] AC-1: Dispatch standard defines fast batches
  - Given the dispatch standard
  - When a test reads its `## Fast batches` section
  - Then it names `plan/.run-speed`, one message, disjoint files, phases in order, and gates
- [ ] AC-2: Each phase skill lists its fast batch
  - Given the plan, implement, validate-and-accept, and ship skills
  - When a test reads each skill
  - Then each holds a `### Fast batch` heading whose section names `plan/.run-speed`
- [ ] AC-3: Orchestrator applies the speed at each transition
  - Given the orchestrator skill
  - When a test reads its Phase Invocation section
  - Then it names `plan/.run-speed` and the fast batch

## Dependencies
- REQ-001
