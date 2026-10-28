---
title: "Feature Brief - watcher false events"
summary: "Stop the initiative watcher reporting stale logs, old commits, and lock state that are false."
status: "approved"
version: "0.1.0"
---
# Feature Brief - watcher false events

**Feature ID:** 0000241-watcher-false-events

> Built from backlog entry 0000216 by initiative 0000238 step 3. Entry folder deleted in the same commit.

## Business Goal

During initiative 0000195 step 13 the watcher sent false events. The human could not tell progress from noise, and the initiative session stopped the watcher. After this step the watcher reports only true stale states, true new commits, and the real lock state.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Stale threshold | As an initiative owner, I want a stale line only when a commit is at least 15 minutes newer than the log, so that a commit seconds after a log write is not flagged | must-have | 1 |
| Stale once | As an initiative owner, I want each stale state reported once, so that the same warning does not repeat every pass | must-have | 1 |
| Branch change | As an initiative owner, I want a switch to another branch reported in one line, so that old commits do not appear as new events | must-have | 1 |
| Lock state | As an initiative owner, I want the heartbeat to show the lock as free once the lock file is gone, so that it matches the driver | must-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack scripts, skills, standards, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Watcher state (in memory) | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-watch.mjs` | git | `spawnSync` with an argument array | adds `git merge-base --is-ancestor` and `git log {last-seen}..HEAD` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ESM, no dependencies) |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Stale line needs a commit at least the stale interval (15 minutes) newer than the last log write.
- Each stale state prints once until the log or the commit changes.
- A last-seen commit that is not an ancestor of `HEAD` prints one branch-change line and no commit lines. Otherwise the watcher lists commits from `git log {last-seen}..HEAD`.
- The heartbeat reads the lock state on each heartbeat.
- A `--passes <n>` test aid, so `--once` tests can cover several passes.
- Tests, watcher header comment, and roadmap standards text.

### Out of Scope
- Changes to the driver, the skill, or any hook.
- New event kinds.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Noise | One stale line per stale state. One line per branch change | Tests with `--once` and `--passes` |
| Safety | Watcher writes no file and runs only fixed git argument arrays | Existing safety tests |

## Constraints and Assumptions

### Constraints
- No new dependency. No change to a fail-closed hook.
- The skill files share a 1,720-line cap. This step adds none.

### Assumptions
- The heartbeat already reads the lock file on each pass. The lock test guards that behaviour.

## Scenario Paths

**Happy path:** A commit lands 5 seconds after the last log write. The watcher prints no stale line.

> As stated.

**First-run path:** No last-seen commit exists. The watcher records `HEAD` and prints no commit lines.

> As stated.

**Error / sad path:** The last-seen commit is unknown to git. The watcher prints one branch-change line and records `HEAD`.

> As stated.

**Cross-session continuity:** State stays in memory. A restarted watcher starts from `HEAD`.

> As stated.

## Acceptance Criteria

- [ ] A commit 5 seconds newer than the log gives no stale line.
- [ ] A real stale state gives one stale line across three passes.
- [ ] A switch to a branch that holds 100 unseen older commits gives one branch-change line and no commit lines.
- [ ] A heartbeat after the lock file is removed reports the lock as free.
