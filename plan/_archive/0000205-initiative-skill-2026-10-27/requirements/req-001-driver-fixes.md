# Requirement: REQ-001 - driver fixes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-004
**Priority:** must-have

## User Story

As the human on the loop, I see the driver stop on an archived `Blocked:` line, advance only after the merge, and keep step subagents running, so that no step is lost.

## Functional Requirements
- After each step, the driver checks the `Blocked:` rule in `plan/current/build-log.md` and in the newest folder under `plan/_archive/` whose name starts with the feature id of the step. An unresolved `Blocked:` line in either stops the driver.
- The driver reads `position` after a step from the initiative branch ref (`git show {branch}:plan/current-initiative/initiative.md`), so a step that did not merge leaves `position` unmoved. Outside a git work tree it reads the working tree.
- The stop line for an unmoved position says the step is not merged into the initiative branch.
- The driver sets `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` in each step session's environment, unless the parent environment already sets it.
- `ravintio-zero/scripts/initiative-run.mjs` header comments describe the new rules.

## Acceptance Criteria
- [ ] AC-1: an archived block stops the driver
  - Given a stub step session that archives a build log ending on a `Blocked:` line
  - When the driver finishes that step
  - Then the driver exits 1 with a `Blocked:` line that repeats the message
- [ ] AC-2: position moves only after the merge
  - Given a stub step session that edits `position` on a feature branch and does not merge
  - When the driver finishes that step
  - Then the driver exits 1 and the stop line says the step is not merged
- [ ] AC-3: the environment keeps the subagents running
  - Given a stub step session that writes its environment to a file
  - When the driver runs with the variable unset, then set to `5`
  - Then the file holds `0` in the first run and `5` in the second

## Dependencies
- None
