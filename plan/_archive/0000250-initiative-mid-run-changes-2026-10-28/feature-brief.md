---
title: "Feature Brief - initiative mid-run changes"
summary: "Adds a routing rule for repo instructions that arrive during an initiative run, and makes the driver stop for a restart when a step changed the driver, the watcher, or the initiative skill."
status: "approved"
version: "0.1.0"
---
# Feature Brief - initiative mid-run changes

**Feature ID:** 0000250-initiative-mid-run-changes

Source: backlog entries 0000226 and 0000227, pulled in by initiative 0000238 step 12. Both entry folders are deleted in this run's commit after the brief.

## Business Goal

Two things go wrong when the world changes during an initiative run. A repo instruction that the human asks for mid-run has no route, so the initiative session tries a write that `gate-write` correctly blocks. A step that changes the driver, the watcher, or the initiative skill leaves later steps on the old code, because the driver loads its code once. The initiative skill gets a routing rule for the first case. The driver stops for a restart in the second case and names the changed files.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Route a mid-run repo instruction into step scope | As a maintainer, I see the initiative skill add a repo instruction that I ask for mid-run to the scope of the current or next pending step in `initiative.md`, so that a step writes the override and `gate-write` stays as it is. | must-have | 1 |
| Stop for a restart after a tooling change | As a maintainer, I see the driver stop after a merged step that changed `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill, and name the changed files, so that the next step runs the new code. | must-have | 1 |
| Restart without a prompt | As a maintainer, I see the initiative skill restart the driver and the watcher when the driver prints the restart stop, so that I do not have to ask. | must-have | 1 |

## Wanted outcome

- A test reads the routing rule in `ravintio-zero/skills/ravintio-initiative/SKILL.md`. The rule names `initiative.md` as the target and the current or next pending step as the scope. The `gate-write` hook and its tests stay unchanged.
- A driver test changes `initiative-run.mjs` in a step and sees the driver stop with a line that names the file. A restarted driver runs the next step.
- A test changes the watcher or the initiative skill in a step and sees a stop that names the change.
- A step that changes none of the three files gives no restart.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver, the initiative skill, the roadmap standards, and the tests |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

The driver calls `git` with an argument array and no shell, as it does today.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js with no dependencies for the driver. Bash tests |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A routing rule in `ravintio-initiative/SKILL.md` for a repo instruction that arrives during a run.
- A change check in `initiative-run.mjs` between steps, and a restart stop line.
- A restart rule in `ravintio-initiative/SKILL.md`.
- The same rules in `roadmap-standards.md`, the driver header, and the component docs.
- Tests, docs, and the version bump.

### Out of Scope
- A driver that restarts itself in a new process.
- A change to `gate-write`, `merge-guard`, or another fail-closed hook.
- A change to the watcher.
- Checking changes to other files, such as the orchestrator skill.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |
| False restarts | 0 restarts when a step changes none of the three files | the driver test |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.
- The driver stays dependency-free and never uses a shell.

### Assumptions
- The initiative branch ref moves when a step merges, because the driver already reads position from it. Impact if wrong: the change check sees no change and gives no restart. The existing "not merged" stop covers that case.

## Scenario Paths

**Happy path:** A step changes `initiative-run.mjs` and merges.

> The driver prints a restart line that names the file and exits 1. The initiative skill starts a new driver and watcher. The next step runs the new code.

**Alternative path:** The human asks for a repo instruction while a step runs.

> The initiative skill queues the instruction. When the driver is between steps or stopped, it adds the instruction to the scope of the next pending step in `initiative.md` and commits it. That step writes the override.

**Error / sad path:** The branch ref is unreadable, or the root is not a git work tree.

> The change check is skipped and no restart happens. The existing position and merge checks still run.

**Cross-session continuity:** A new driver starts after the restart stop.

> The new driver reads position from the initiative branch ref and runs the step at that position. No state carries across.

## Acceptance Criteria

- [ ] The routing rule in the initiative skill names `initiative.md` as the target and the current or next pending step as the scope. The `gate-write` hook and its tests are unchanged.
- [ ] A step that changes `initiative-run.mjs` makes the driver stop with a line that names the file, and the next step does not start under that driver.
- [ ] A step that changes `initiative-watch.mjs` or the initiative skill also makes the driver stop with a line that names the change.
- [ ] A step that changes none of the three files gives no restart.
- [ ] The initiative skill restarts the driver and the watcher on the restart stop without asking.
