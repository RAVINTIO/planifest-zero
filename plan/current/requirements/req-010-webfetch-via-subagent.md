---
title: "Requirement: req-010 - webfetch-via-subagent"
summary: "The dispatch standard routes a WebFetch of a full reference page through a sonnet or haiku subagent that returns only the extract."
status: "draft"
version: "0.1.0"
---
# Requirement: req-010 - webfetch-via-subagent

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (token efficiency, backlog 0000148 change 5)
**Priority:** should-have

## User Story

As the person paying for runs, I want large web pages read outside the main session, so that an 87 KB page does not stay in context and get re-read on every turn.

## Functional Requirements
- `planifest-zero/standards/agent-dispatch-standards.md` gains a rule for `WebFetch` of a full reference page.
  - The fetch runs in a subagent on `sonnet` or `haiku`.
  - The dispatch prompt names the extract the parent needs.
  - The subagent returns only that extract, not the page.
- The rule follows REQ-007: the dispatch passes `model` explicitly.
- A fetch of a small page that the parent needs in full may run in the main session.
- P2 edits the source standard only, then reruns setup so the installed copies match.

## Acceptance Criteria
- [ ] (a) The standard contains the WebFetch rule, and the rule names `sonnet` or `haiku`, a subagent, and a returned extract. A prose check greps for these terms in one section.
- [ ] (b) The standard states that the dispatch passes `model`.
- [ ] (c) After setup, the installed copies under `.claude/skills/*/references/agent-dispatch-standards.md` match the source.
- [ ] (d) The existing test suite passes with no assertion removed or relaxed.

## Dependencies
- REQ-007 edits other sections of the same file.
- Files in reach:
  - `planifest-zero/standards/agent-dispatch-standards.md`
  - `planifest-zero/tests/test-0000151-req-010-webfetch-via-subagent.sh` (new, a prose check)
