# Requirement: REQ-001 - improvement loop after GREEN

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I get up to 2 improvement cycles per requirement after GREEN, so that a working solution is simplified before it ships.

## Functional Requirements
- `ravintio-zero/skills/ravintio-implement/SKILL.md` adds a short `## Improvement loop` section. It runs after ravintio-refactor confirms all-suite GREEN, caps the loop at 2 cycles per requirement, and points to `## Improvement loop` in `ravintio-zero/standards/agent-dispatch-standards.md`. The standard holds the cycle steps, because the skills text has a line budget (test 0000031).
- Each cycle dispatches a reviewer in a fresh context. The reviewer reads the requirement, the test, and the implementation. It returns a finding, or the text `no change worth making`.
- If the reviewer finds nothing worth changing, the loop stops early.
- If the reviewer returns a finding, ravintio-implement dispatches ravintio-refactor in improvement mode with that finding. The full suite then runs.
- If the suite fails after a change, the change is reverted and the cycle records that.
- Each cycle appends an `Improve:` marker to the build log. A resumed run counts the markers for the requirement and runs only the cycles that remain.
- The TDD loop pseudocode and the fast batch in the implement skill name the improvement loop.
- `ravintio-zero/skills/ravintio-refactor/SKILL.md` describes improvement mode in its output section. Its hard limits stay in force. It applies only the change the reviewer named and reverts it if the suite fails.

## Acceptance Criteria
- [ ] AC-1: the implement skill runs a capped loop after GREEN
  - Given the implement skill and the dispatch standard
  - When a test reads the skill's `## Improvement loop` section and the TDD loop block
  - Then the section caps the loop at 2 cycles per requirement, points to the standard, and the block names the loop after refactor
- [ ] AC-2: the reviewer is fresh and the loop stops early
  - Given the implement skill and the dispatch standard
  - When a test reads their `## Improvement loop` sections
  - Then the two sections require a fresh-context reviewer, the text `no change worth making`, an early stop, a revert on a failed suite, and a resume count from the build log markers
- [ ] AC-3: the refactor skill has an improvement mode
  - Given the refactor skill
  - When a test reads its text
  - Then the text keeps the hard limits, applies only the reviewer's finding, and reverts on a failed suite

## Dependencies
- None
