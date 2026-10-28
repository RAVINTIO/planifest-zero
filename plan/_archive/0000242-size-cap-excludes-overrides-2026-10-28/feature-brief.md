---
title: "Feature Brief - size cap excludes overrides"
summary: "Make the orchestrator size cap test measure pack content only, so a repo override never changes its result."
status: "approved"
version: "0.1.0"
---
# Feature Brief - size cap excludes overrides

**Feature ID:** 0000242-size-cap-excludes-overrides

> Built from backlog entry 0000214 by initiative 0000238 step 4. Entry folder deleted in the same commit.

## Business Goal

Test `test-0000151-req-011` adds the repo `CLAUDE.md` to `SKILL.md` and caps the sum. `CLAUDE.md` includes every file in `ravintio-overrides/instructions/`, so each new override can fail a pack test. Initiative 0000195 step 13 raised the cap to 38,200 to absorb one override. After this step the cap covers pack content only, and adding an override never changes the result.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pack-only measure | As a pack maintainer, I want the size cap to measure the boot file without the override block, so that adding an override never changes the result | must-have | 1 |
| Pack-only cap | As a pack maintainer, I want the cap set to the pack-only figure, so that a pack change that grows the boot file or `SKILL.md` still fails the test | must-have | 1 |

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
| Size cap test | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- The size cap check in `test-0000151-req-011-orchestrator-references-split.sh` strips the `ravintio-overrides:instructions` block from `CLAUDE.md` before it counts bytes.
- The combined cap becomes the pack-only figure with a small margin.
- Tests that prove an added override leaves the measure unchanged and that pack growth still fails the cap.

### Out of Scope
- The separate `SKILL.md` cap (27,800 bytes). Step 6 changes it.
- Changes to `setup.sh`, `setup.ps1`, or the boot templates.
- The `CLAUDE.md` size cap. Step 7 owns it.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The same pack content gives the same measure, with or without overrides | Test with a temporary override block |

## Constraints and Assumptions

### Constraints
- No new dependency. No change to `merge-guard`, `gate-write`, or any other hook.

### Assumptions
- The repo `CLAUDE.md` outside the override markers equals the boot template. Impact if wrong: the measure differs from the template by a few bytes and the margin absorbs it.

## Scenario Paths

**Happy path:** The test strips the override block, sums the result with `SKILL.md`, and passes under the cap.

> Strip, sum, compare.

**First-run path:** A repo with no override block has nothing to strip, and the measure equals the full `CLAUDE.md`.

> The strip is a no-op.

**Error / sad path:** A pack change grows `SKILL.md` or the boot text past the cap, and the test fails.

> A mutation check proves it.

**Cross-session continuity:** The test is stateless. An interrupted run leaves no state.

> Not applicable.

## Acceptance Criteria

- [ ] Appending an override block to `CLAUDE.md` leaves the size cap result unchanged.
- [ ] Growing `SKILL.md` or the pack part of `CLAUDE.md` past the cap fails the test.
- [ ] The cap equals the pack-only figure plus a stated margin.
