---
title: "Requirement: req-007 - dispatch-model-tiers"
summary: "The dispatch standard names the Agent tool's model values, every Agent call passes model, and TDD dispatches use each skill's tier."
status: "draft"
version: "0.1.0"
---
# Requirement: req-007 - dispatch-model-tiers

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (token efficiency, backlog 0000148 change 2)
**Priority:** must-have

## User Story

As the person paying for runs, I want every subagent to run on its intended tier, so that cheaper models do the work they suit and my allowance lasts longer.

## Functional Requirements
- `planifest-zero/standards/agent-dispatch-standards.md` replaces the stale IDs `claude-sonnet-4-6` and `claude-haiku-4-5` with the Agent tool's `model` values `sonnet` and `haiku`.
  - The tier table (about line 35) names `sonnet` and `haiku`.
  - The dispatch examples (about lines 79 and 82) pass `model: "haiku"`.
- The standard states that an Agent call without `model` inherits the parent's model. It then states that every Agent call passes `model` explicitly.
- `planifest-zero/skills/planifest-implement/SKILL.md` (TDD inner loop, about lines 48 to 61) dispatches each of these skills with the `model` from that skill's own `recommended_model` field:
  - `planifest-test-writer`
  - `planifest-implementer`
  - `planifest-refactor`
- If a haiku unit fails twice, the dispatcher retries that unit on `sonnet`.
- The five-attempt escalation rule is unchanged. The two haiku failures count toward the five attempts.
- P2 checks whether Claude Code honours a skill-level `model` frontmatter field.
  - If it does, P2 sets that field in the three TDD skills and records the evidence in the build log.
  - If it does not, P2 keeps the explicit `model` parameter on each Agent call and records that result.
  - Either way, the explicit `model` parameter stays, so the outcome never removes a tier.
- The installed copies under `.claude/skills/*/references/` come from `setup.sh` through the `bundle_standards` frontmatter. P2 edits only the source files, then reruns setup.

## Acceptance Criteria
- [ ] (a) Standard and skill wording. Every check below holds.
  - `agent-dispatch-standards.md` contains no `claude-sonnet-4-6` or `claude-haiku-4-5`. Its tier table and examples use `sonnet` and `haiku`. A test greps for the absence and presence.
  - The standard contains a sentence that an Agent call without `model` inherits the parent's model, and a rule that every call passes `model`. A test greps for both.
  - `planifest-implement/SKILL.md` names `recommended_model` as the source of the model for the test-writer, implementer, and refactor dispatches. A test greps for it in the TDD loop section.
  - `planifest-implement/SKILL.md` states that a haiku unit failing twice retries on `sonnet`, and that the five-attempt escalation is unchanged. A test greps for both.
- [ ] (b) Build log and installed copies. Every check below holds.
  - The build log holds one line that records whether Claude Code honours a skill-level `model` field, with the evidence.
  - After rerunning setup, no file under `.claude/skills/*/references/agent-dispatch-standards.md` differs from the source. A test compares them.
- [ ] (c) Existing tests. Every check below holds.
  - The existing test suite passes with no assertion removed or relaxed.

## Dependencies
- The ship, validate, and escalation rules in `planifest-implement/SKILL.md` stay as they are.
- Files in reach:
  - `planifest-zero/standards/agent-dispatch-standards.md`
  - `planifest-zero/skills/planifest-implement/SKILL.md`
  - `planifest-zero/skills/planifest-test-writer/SKILL.md`
  - `planifest-zero/skills/planifest-implementer/SKILL.md`
  - `planifest-zero/skills/planifest-refactor/SKILL.md`
  - `planifest-zero/tests/test-0000151-req-007-dispatch-model-tiers.sh` (new)
- REQ-010 adds a rule to the same standard. Both requirements edit different sections.
