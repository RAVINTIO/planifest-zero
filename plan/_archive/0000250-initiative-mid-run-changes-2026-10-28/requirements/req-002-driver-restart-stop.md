---
title: "Requirement: REQ-002 - driver restart stop"
summary: "The driver stops after a merged step that changed the driver, the watcher, or the initiative skill, and names the changed files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - driver restart stop

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000250-initiative-mid-run-changes
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see the driver stop after a merged step that changed `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill, and name the changed files, so that the next step runs the new code.

## Functional Requirements
- Before each step, the driver records the commit that the initiative branch ref points to. After the step, it reads the ref again.
- If the two commits differ, the driver runs `git diff --name-only {before} {after}` limited to `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/scripts/initiative-watch.mjs`, and `ravintio-zero/skills/ravintio-initiative/SKILL.md`.
- If the diff lists any of them, the driver prints `I-D Advance: Restart: step {n} changed {files}. Start a new driver so step {next} runs the new code.`, releases the lock, and exits 1. The line ends with the log path like any stop after a step starts.
- The check runs after the delivery, block, and not-merged checks and before the next step. A delivered or fully merged initiative never restarts.
- If git or either ref is unreadable, the driver skips the check and continues.
- A step that changes none of the three files gives no restart.
- `roadmap-standards.md` and the driver header describe the stop.

## Acceptance Criteria
- [ ] AC-1: a driver change stops the driver
  - Given a step that changes `initiative-run.mjs` and merges
  - When the driver reads the result
  - Then it prints the restart line with the file name, exits 1, and starts no further step
- [ ] AC-2: a watcher or skill change stops the driver
  - Given a step that changes `initiative-watch.mjs` or the initiative skill and merges
  - When the driver reads the result
  - Then it prints the restart line with that file name and exits 1
- [ ] AC-3: no change gives no restart
  - Given a step that changes none of the three files
  - When the driver reads the result
  - Then it runs the next step

## Dependencies
- none
