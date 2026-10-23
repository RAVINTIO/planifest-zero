---
title: "Requirement: req-004 - roadmap-step-discovery"
summary: "Each roadmap step cuts its feature branch from the roadmap branch and runs P0 with self-confirmed design, scope lock, and a per-step version bump."
status: "draft"
version: "0.1.0"
---
# Requirement: req-004 - roadmap-step-discovery

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-004
**Priority:** must-have

## User Story

As a human on the loop, I let each step run P0 to P4 with no coaching stops, so that the chain runs without me.

## Functional Requirements
- R-C Run cuts the step's feature branch from the roadmap branch, not from `main`.
- The step runs in `autonomous` mode.
  - P0 writes `plan/.run-mode` with `autonomous` without asking the run-mode question.
- P0 builds `feature-brief.md` from the backlog entries that the step's row in `roadmap.md` lists.
  - Each entry is pulled in and its folder deleted in the same commit, as for normal backlog pickup.
  - P0 does not ask the pull-in, leave, or discard question for these entries.
- P0 self-confirms the design and the Scope Lock Challenge.
  - Each scope lock line in the build log ends with `[source: draft-accepted (roadmap)]`.
  - The design confirmation records `draft-accepted (roadmap)` in place of a human confirmation.
- P0 stops only when a backlog entry is too vague to draft a brief from.
  - The stop prints a `Blocked:` message that names the entry and what is missing.
  - The exception stops from 0000042 ADR-002 still apply, including the credential stop.
- P0 applies the step's `Bump` to the roadmap branch's version.
  - `Bump` takes `major`, `minor`, or `patch`, and `minor` is the default when the field is empty.
  - The existing downgrade block still applies, and a result lower than the last known version stops P0 with the existing `Blocked:` message.
- All R-C messages use the `R-C Run:` prefix.

## Acceptance Criteria
- [ ] (a) The orchestrator skill states that R-C Run cuts the step's feature branch from the roadmap branch, builds the brief from the step's backlog entries with pull-in and deletion in one commit, and writes `autonomous` to `plan/.run-mode` without asking.
- [ ] (b) The orchestrator skill states that a roadmap step self-confirms the design and records each scope lock line as `draft-accepted (roadmap)`, and that P0 stops only when an entry is too vague to draft from.
- [ ] (c) The orchestrator skill states that P0 applies the step's `Bump` (`major`, `minor`, or `patch`, default `minor`) to the roadmap branch's version and keeps the downgrade block.

## Dependencies
- REQ-002 supplies the `Bump` column and the step table in `roadmap.md`.
- REQ-003 supplies the active roadmap and the roadmap branch that the step branches from.
- REQ-009 supplies the `R-C Run:` prefix and the resume rule that starts a step at `position`.
- 0000042 supplies the `autonomous` run mode, the exception stops, and the `Blocked:` message form.
- A new test checks the criteria by grep: `planifest-zero/tests/test-0000043-req-004-roadmap-step-discovery.sh` (new).
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (Discovery Start Actions 2, 10, and 12, Scope Lock Challenge, and Design Confirmation)
  - `.claude/skills/planifest-orchestrator/SKILL.md` (installed copy, refreshed from the pack)
  - `planifest-zero/templates/build-log.template.md` (only if it needs a `draft-accepted (roadmap)` example)
  - `planifest-zero/pipeline-reference.md` (only if it describes the P0 confirmation rule)
