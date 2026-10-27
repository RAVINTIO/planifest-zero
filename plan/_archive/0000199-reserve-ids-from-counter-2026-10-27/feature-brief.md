---
title: "Feature Brief - reserve ids from a counter"
summary: "Backlog, feature, and initiative ids come from one counter file that a script reserves under a lock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - reserve ids from a counter

**Feature ID:** 0000199-reserve-ids-from-counter

> Built from backlog entry 0000183 by initiative 0000195 step 4. The entry folder is deleted in the same commit.

## Business Goal

An agent that files a backlog entry picks "the highest id ever allocated plus one" by scanning folders in the working tree. The scan misses ids on other branches, ids that pickup deleted, and ids that a copy carries from another repo. Backlog id 0000026 appears twice in each repo's history, and two sessions nearly took 0000183 together on 2026-10-25. A counter file at `plan/backlog/.next-id`, reserved by one script under a lock, makes every new id unique without a search.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Reserve ids with a script | US-001: As an agent that files an entry or starts a feature, I reserve ids from `plan/backlog/.next-id` with one script, so that two sessions never take the same id. | must-have | 1 |
| Call the counter from every id rule | US-002: As an agent that copies an entry from another repo, I reserve a new local id and name the source id in the text, so that each repo keeps its own sequence and no id clashes. | must-have | 1 |

## Waves

One wave. The release holds two features.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All | The reservation tests pass and no doc still states the folder-scan rule |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Setup scripts, skills, hooks, standards, and tests |

### Data Ownership

The counter file `plan/backlog/.next-id` holds one seven-digit number. `ravintio-zero` owns it. No datastore.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM) and Bash |
| Runtime | node, bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | pack shell test suites (`run-tests.sh`) |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/reserve-id.mjs` reserves a block of ids from a counter file under an exclusive lock.
- `plan/backlog/.next-id` ships seeded at `0000210`.
- The file-backlog skill, the orchestrator's backlog pickup, the backlog and initiative templates, `roadmap-standards.md`, and `agent-dispatch-standards.md` call the script in place of the folder scan.
- A copied entry reserves a local id and names its source id in the text.
- One new test suite checks the script and the docs.

### Out of Scope
- Renumbering any existing id.
- A hook or CI check that rejects a hand-written id.
- Scanning every git ref. The counter replaces the scan.
- Setup changes. The script lives in `ravintio-zero/scripts/` and needs no install step.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Atomic reservation | Two reservations that start at once return ranges that do not overlap, and the file ends at the sum | A test starts 8 reservations at once and checks the ids and the final value |
| Fail closed | A held lock, a bad counter, or a bad quantity exits non-zero and leaves the file unchanged | Tests assert the exit code and the file bytes |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of the orchestrator apply. No schema change.
- The script uses Node built-ins only.
- Ids stay seven digits wide, or the width of the counter file.

### Assumptions
- A merge conflict on `.next-id` resolves by keeping the higher value, then renumbering the entries on the branch that merges second. The human pre-approved this answer in the backlog entry.
- Sessions in one repo share one working tree or push the counter with each reservation commit.

## Scenario Paths

**Happy path:** Reserving 4 ids from `0000188` returns `0000188` to `0000191` and leaves `0000192` in the file.

> Consecutive ids, and the next free id in the file.

**First-run path:** A repo with no counter file has no sequence yet. The script stops and says so. With `--init` it seeds the file from the highest id in `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/`, plus one.

> One bootstrap scan, then the counter rules.

**Error / sad path:** A held lock, a malformed counter, a symlinked counter, or a bad quantity makes the script exit non-zero and write nothing.

> Fail closed.

**Cross-session continuity:** The counter file is the only state. Two sessions that reserve at once take disjoint ranges, and a branch that reserves the same ids shows a merge conflict on `.next-id`.

> Git reports the clash that the lock cannot see.

## Acceptance Criteria

- [ ] Reserving 4 ids from `0000188` returns `0000188` to `0000191` and leaves `0000192` in the file.
- [ ] Two reservations that start at once return ids that do not overlap.
- [ ] A copied entry gets a local id from the counter and names its source id.
- [ ] No pack doc states the "highest ever allocated plus one" scan rule.
