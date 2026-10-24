---
title: "Requirement: req-009 - context-size-at-gates"
summary: "At each phase gate in an interactive run, the orchestrator states the approximate context size and recommends /clear past about 150,000 tokens."
status: "draft"
version: "0.1.0"
---
# Requirement: req-009 - context-size-at-gates

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (backlog 0000148)
**Priority:** must-have

## User Story

As the person paying for runs, I see the context size at each gate and a prompt to clear it, so that long sessions stop re-reading a large history on every turn.

## Functional Requirements
- At each phase gate in an interactive (gated) run, the orchestrator states the approximate context size before it asks for approval.
  - The P0 design gate counts as a phase gate.
  - The P1, P2, and P3 gates and the P4 ship gate count too.
- The orchestrator estimates the size in this order:
  - It uses the usage figure the host reports, such as the context meter in Claude Code.
  - If the host reports none, it gives a stated estimate and labels it as an estimate.
- If the size passes about 150,000 tokens, the orchestrator recommends `/clear` or a new session before the next phase.
  - The `plan/current/` artifacts carry state between sessions, so a clear loses no pipeline state.
  - The recommendation names the resume route: start the new session and let Resume Detection continue from the build log.
- The statement is advisory. The orchestrator never blocks, delays, or skips a gate because of context size.
- The rule applies in interactive runs only.
  - A continuous run or a roadmap step does not stop to report context size.
  - Each roadmap step already starts a fresh session.
- The orchestrator holds the rule in one place, in `planifest-zero/skills/planifest-orchestrator/SKILL.md`, in the gate section that each phase gate already cites.
- The rule leaves every existing gate check, approval question, and exception stop unchanged.

## Acceptance Criteria
- [ ] (a) Prose content. Every check below holds.
  - The orchestrator `SKILL.md`, or a `references/` file that it names in the Pack Index, contains the figure `150,000` and the words `/clear`.
  - The text says the statement happens at each phase gate in an interactive run and names the P0 design gate.
  - The text says how the agent estimates size, with the host-reported usage first and a labelled estimate second.
  - The text says the statement is advisory and never blocks a gate.
  - The text says a continuous run and a roadmap step do not report context size.
- [ ] (b) Prose check test. Every check below holds.
  - A prose check test greps for every check in (a) and passes. The test also keeps every assertion in the existing gate tests, such as `test-0000042-req-002-gate-and-exception-stops.sh`, unchanged and passing.
- [ ] (c) Existing gate assertions. Every check below holds.
  - No existing assertion about a gate, an approval question, or an exception stop is removed or loosened.

## Dependencies
- REQ-011 may move text out of the orchestrator `SKILL.md`. Keep this rule inline, next to the gate text, so a moved section never hides it.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (edit)
  - `planifest-zero/tests/test-0000151-req-009-context-size-at-gates.sh` (new, prose check)
  - `planifest-zero/tests/helpers/assert.sh` (existing test helpers)
- Docs: the orchestrator change needs no new component manifest. Record the rule in the feature's build log and changelog entry.
