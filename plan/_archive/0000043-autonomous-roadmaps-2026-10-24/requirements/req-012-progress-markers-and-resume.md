---
title: "Requirement: req-012 - progress-markers-and-resume"
summary: "Each dispatched unit logs when it starts and finishes, so a resumed session reruns an interrupted unit instead of trusting its left-over files."
status: "draft"
version: "0.1.0"
---
# Requirement: req-012 - progress-markers-and-resume

**Skill:** [implement](../skills/planifest-implement/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-004, US-007
**Priority:** must-have

## User Story

As a human on the loop, I rely on a resumed session to know exactly which unit of work a stop interrupted, so that a stopped driver restarts with no guesswork and no lost or half-written work.

Added at P3 by a human-confirmed design change. In the live acceptance run's stop-and-restart test, the resumed session committed half-written test files from the stopped unit without checking them. It also left no trace of the stop.

## Functional Requirements
- Before each dispatched unit starts, the phase appends `- In progress: {unit} ({ISO-8601 timestamp})` to the build log and commits it.
  - A unit is a TDD subagent in P2, a self-correct cycle in P3, or any subagent dispatched under the agent dispatch standards.
  - `{unit}` names the requirement and stage, for example `REQ-001 test-writer`.
  - When the unit finishes, the phase appends `- Done: {unit} ({ISO-8601 timestamp})` in the same commit as the unit's work.
- On resume, an `In progress:` line with no later matching `Done:` line marks an interrupted unit.
  - If the working tree has uncommitted changes, the session stashes them with `git stash push --include-untracked -m "interrupted {unit}"`. It never discards them.
  - The session reruns the unit from its start, then logs `- Resumed after interruption: {unit}` and commits.
  - The session never commits files an interrupted unit left behind without rerunning that unit.
- The roadmap driver reads only `Blocked:` and `Resolved:` lines, so progress markers never stop it.

## Acceptance Criteria
- [ ] (a) The agent dispatch standard defines the `In progress:` and `Done:` lines and their commits. The implement and validate skills point to it, and the build-log template documents the lines.
- [ ] (b) The standard states that an `In progress:` line with no later matching `Done:` line marks an interrupted unit. The session stashes uncommitted changes under a named stash, reruns the unit from its start, and logs `Resumed after interruption:`. The orchestrator's Resume Detection has an interrupted-unit step before Open that points to the standard.
- [ ] (c) A build log that ends on an unmatched `In progress:` line does not stop the roadmap driver.

## Dependencies
- REQ-007 supplies the driver and its `Blocked:` detection.
- REQ-009 supplies Resume Detection for roadmap steps.
- ADR-007 records the decision.
- Files in reach:
  - `planifest-zero/standards/agent-dispatch-standards.md`
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (one Resume Detection step)
  - `planifest-zero/skills/planifest-implement/SKILL.md` (one pointer clause)
  - `planifest-zero/skills/planifest-validate-and-accept/SKILL.md` (one pointer clause)
  - `planifest-zero/templates/build-log.template.md`
  - `planifest-zero/tests/test-0000043-req-012-progress-markers-and-resume.sh` (new)
