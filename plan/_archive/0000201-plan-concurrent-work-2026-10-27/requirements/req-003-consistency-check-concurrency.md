# Requirement: REQ-003 - consistency check 8 for the concurrency plan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Source:** US-003
**Priority:** must-have

## User Story

As the human on the loop, I get a consistency check that fails an execution plan with no concurrency section or with an unjustified sequential unit, so that no plan reaches the gate without batches.

## Functional Requirements
- `consistency-check.mjs` reads `execution-plan.md` when it exists and skips the check when it does not.
- The check reports a finding when the file has no `## Concurrency plan` section, when the section has no table with the five columns, or when the table has no unit row.
- The check reports a finding for a row with a `Batch` that is not a positive whole number.
- The check reports a finding for a unit that is alone in its batch and has an empty `Sequential reason`. The values `none` and `-` count as empty.
- The check reports a finding for two units in one batch whose `Writes` lists share a path.
- The check reports a finding for a `Depends on` entry that names no unit, or names a unit in the same or a later batch.
- Each finding names the unit and prints it through the 200-character cap.
- The header comment of the script lists check 8.

## Acceptance Criteria
- [ ] AC-1: a valid plan passes
  - Given an execution plan with a concurrency table whose batches are valid
  - When the check runs
  - Then it prints no concurrency finding
- [ ] AC-2: a plan without the section fails
  - Given an execution plan with no `## Concurrency plan` section
  - When the check runs
  - Then it exits 1 and the finding names the missing section
- [ ] AC-3: a bad row fails
  - Given a table with an unjustified sequential unit, a shared write target in one batch, or a dependency on a later batch
  - When the check runs
  - Then it exits 1 and each finding names the unit

## Dependencies
- REQ-001 defines the table format.
