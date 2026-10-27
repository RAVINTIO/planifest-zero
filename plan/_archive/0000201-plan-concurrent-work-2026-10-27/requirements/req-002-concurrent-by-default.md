# Requirement: REQ-002 - concurrent by default, sequence with a reason

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I get concurrent dispatch for any two units with no dependency and no shared write target, and a stated reason for each unit that runs in sequence, so that sequence is a decision and not a habit.

## Functional Requirements
- `ravintio-zero/standards/agent-dispatch-standards.md` holds a `## Concurrency plan` section. It states that two units with no dependency and no shared write target share a batch.
- The same section states that a unit alone in its batch gives its reason in the plan's `Sequential reason` column.
- The same section states that dispatch follows the plan's batches and that a departure from them is recorded in the build log with its reason.
- `ravintio-zero/skills/ravintio-implement/SKILL.md` tells the implement phase to dispatch by the plan's batches.
- `ravintio-zero/skills/ravintio-plan/SKILL.md` tells the plan skill to place two such units in one batch.

## Acceptance Criteria
- [ ] AC-1: the standard states the default
  - Given the dispatch standard
  - When a test reads its concurrency section
  - Then it names the no-dependency and no-shared-write rule and the sequential reason
- [ ] AC-2: the standard covers departures
  - Given the dispatch standard
  - When a test searches the concurrency section for the departure rule
  - Then it requires a build log entry with the reason
- [ ] AC-3: implement dispatches by batch
  - Given the implement skill
  - When a test searches for the batch rule
  - Then the skill names the plan's concurrency plan as the source of batches

## Dependencies
- REQ-001 defines the table that this requirement refers to.
