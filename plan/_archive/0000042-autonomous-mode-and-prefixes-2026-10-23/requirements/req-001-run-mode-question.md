---
title: "Requirement: req-001 - run-mode-question"
summary: "The orchestrator asks one run-mode question at the end of P0 and records gated or autonomous."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - run-mode-question

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a human on the loop, I choose `gated` or `autonomous` at the end of P0, so that the agent either stops for me at each phase gate or runs to a raised pull request.

## Functional Requirements
- The orchestrator ends P0 by asking this question, verbatim:

  ```
  How should the agent run P1 to P4?

    [1] Gated: the agent stops for you at the end of each phase
    [2] Autonomous: the agent runs to a raised PR and stops only for escalations
  ```

- The orchestrator writes `gated` or `autonomous` to `plan/.run-mode` and logs the choice in the build log.
  - No other value is valid.
  - `interactive` and `continuous` are retired. No skill, doc, template, hook, or test uses them as run-mode values.
- The phases are P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. REQ-004 to REQ-006 (phase numbers and prefixes) own this numbering.

## Acceptance Criteria
- [ ] (a) The orchestrator skill holds the run-mode question text exactly as above, offers only `[1] Gated` and `[2] Autonomous`, and writes `gated` or `autonomous` to `plan/.run-mode`.
- [ ] (b) A grep for `continuous` and `interactive` as run-mode values finds no match in the files in reach. The 0000023 tests assert `gated` and `autonomous` instead.

## Dependencies
- REQ-004 to REQ-006 (phase numbers and prefixes) supply the phase numbers and prefixes used here.
- REQ-002 defines the stops that each mode applies. REQ-003 defines how a run restores its mode.
- 0000023 set the continuous run gate rules that this feature replaces.
- Files in reach (from a grep for `continuous`, `interactive`, and `run-mode` in `planifest-zero/`, excluding history):
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md`
  - `planifest-zero/getting-started.md`
  - `planifest-zero/workflows/feature-pipeline.md`
  - `planifest-zero/tests/test-0000023-req-001-continuous-run-p1-p3.sh`
  - `planifest-zero/tests/test-0000023-req-002-marker-commit-lifecycle.sh`
- `planifest-zero/standards/reference/frontend-stack-evaluation.md` also matches the grep. It uses the words generically, so leave it unchanged.
