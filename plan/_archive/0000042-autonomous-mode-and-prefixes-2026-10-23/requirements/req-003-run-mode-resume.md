---
title: "Requirement: req-003 - run-mode-resume"
summary: "A resumed run restores a valid mode without asking and asks again when the mode is missing or unknown."
status: "draft"
version: "0.1.0"
---
# Requirement: req-003 - run-mode-resume

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a human on the loop, I resume a run in a new session, so that the agent keeps my chosen mode or asks me when it cannot tell which mode I chose.

## Functional Requirements
- On resume, if `plan/.run-mode` is missing or holds an unknown value, the orchestrator asks the run-mode question from REQ-001.
  - The question names the value it found, or says the file is missing.
  - The orchestrator writes the answer to `plan/.run-mode` and logs it in the build log.
- The fresh-start stale check is unchanged.
- In a new session, if `plan/.run-mode` holds a valid mode, the orchestrator restores that mode without asking.
  - It reads `plan/.run-mode` and the build log first, then resumes at the last phase with that phase's prefix.
  - A gated run shows its pending gate again.
- `pipeline-reference.md` drops its rule that let continuous run skip a clean acceptance gate. The skills are the single source for gate behaviour.

## Acceptance Criteria
- [ ] (a) A missing `plan/.run-mode` and an unknown value such as `continuous` each make the orchestrator ask the run-mode question, name what it found, write the answer, and log it.
- [ ] (b) A new session with a valid `plan/.run-mode` restores that mode without asking. A gated run shows its pending gate again.
- [ ] (c) `pipeline-reference.md` no longer lets any mode skip a clean acceptance gate.

## Dependencies
- REQ-001 defines the run-mode question and the valid values.
- REQ-002 defines the gates that a gated run shows again.
- REQ-004 to REQ-006 (phase numbers and prefixes) supply the phase prefixes used on resume.
- Files in reach:
  - `planifest-zero/pipeline-reference.md`
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md`
