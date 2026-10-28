---
title: "Requirement: REQ-001 - Driver starts steps with stream-json"
summary: "Driver starts steps with stream-json"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver starts steps with stream-json

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative owner, I want the driver to start each step with stream-json output, so that the step log fills as the session works.

## Functional Requirements
- `initiative-run.mjs` passes `--output-format stream-json --verbose` to `claude -p`.
- The driver keeps `--permission-mode`, `--model`, `--max-turns`, and the prompt argument as before.
- The log keeps mode 600.

## Acceptance Criteria
- [ ] AC-1: stream args present
  - Given a stub `claude` that records its arguments
  - When the driver runs a step
  - Then the recorded arguments hold `--output-format stream-json --verbose` and the prompt `Run initiative step {n}`
- [ ] AC-2: log written as the stream
  - Given a stub `claude` that prints JSON lines
  - When the step ends
  - Then `plan/.initiative-logs/step-{n}.log` holds those lines and has mode 600

## Dependencies
- None
