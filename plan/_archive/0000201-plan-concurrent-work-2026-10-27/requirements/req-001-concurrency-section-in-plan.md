# Requirement: REQ-001 - concurrency section in the execution plan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I see a concurrency plan in every execution plan, and in any re-plan after a reopened phase, so that I know which work runs at once before the work starts.

## Functional Requirements
- `ravintio-zero/templates/execution-plan.template.md` holds a `## Concurrency plan` section before `## Assumptions`. The section holds a table with the columns `Unit`, `Depends on`, `Writes`, `Batch`, and `Sequential reason`.
- `ravintio-zero/templates/execution-plan-guide.md` explains each column and shows one worked example.
- `ravintio-zero/skills/ravintio-plan/SKILL.md` requires the section in each execution plan. It also requires a rewrite of the section in any re-plan after a reopened phase.
- `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-mid-pipeline-changes.md` tells the orchestrator that a P1 re-run rewrites the concurrency plan.

## Acceptance Criteria
- [ ] AC-1: the template carries the section
  - Given the execution plan template
  - When a test reads its headings and the section table header
  - Then `## Concurrency plan` appears before `## Assumptions` with the five columns
- [ ] AC-2: the plan skill requires the section
  - Given the plan skill
  - When a test searches for the concurrency rule
  - Then the skill requires the section in each plan and in each re-plan after a reopened phase
- [ ] AC-3: the re-run reference points to the rule
  - Given the mid-pipeline changes reference
  - When a test searches for the re-plan text
  - Then the reference states that a P1 re-run rewrites the concurrency plan

## Dependencies
- None
