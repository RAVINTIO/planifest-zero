---
title: "Feature Brief - ship merge command and wall clock check"
summary: "Gives the ship skill a plain merge command to copy, and adds a build log check that stops ship before archive when a phase wall clock is blank or wrong."
status: "approved"
version: "0.1.0"
---
# Feature Brief - ship merge command and wall clock check

**Feature ID:** 0000248-ship-merge-and-wall-clocks

Source: backlog entries 0000228 and 0000232, pulled in by initiative 0000238 step 10. The entry folders are deleted in this run's commit after the brief.

## Business Goal

In initiative 0000195, `merge-guard` blocked the first merge command in 5 of 15 steps, because each agent built the line with command substitution. Steps 11 to 15 also archived build logs with blank or zero wall clocks, so the retrospective could not compute step times. The ship skill now shows the merge line to copy, and a check stops ship before archive when a wall clock is wrong.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Plain merge command in ship | As a maintainer, I see the ship skill give one plain merge line with a literal PR number, so that `merge-guard` allows the first attempt. | must-have | 1 |
| Build log wall clock check | As a maintainer, I see ship stop before archive when a phase block has a blank or wrong time, so that archived build logs always hold usable wall clocks. | must-have | 1 |

## Wanted outcome

- A test finds the line `gh pr merge --squash --delete-branch {n}` in the ship skill, finds the statement that `{n}` is a literal number and that substitution is forbidden, and confirms `merge-guard` allows the line with a literal number for an `initiative/*` base. The `merge-guard` source and its tests are unchanged.
- A script checks a build log. A blank `End`, a blank `Wall clock`, a `Wall clock` more than one minute from `End` minus `Start`, a missing phase block not marked skipped, and a `Total wall clock` of `not recorded` each fail and name the phase. A complete log from the template passes. Ship runs the script before Archive.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the ship skill, the roadmap standards, the new check script, and the tests |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

The ship skill calls the new script on `plan/current/build-log.md`.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node 20 script and Bash tests already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A plain merge line and its literal-number rule in `ravintio-ship/SKILL.md`, matched in I-D Advance step 4.
- A script `ravintio-zero/scripts/build-log-check.mjs` and a ship step that runs it before Archive.
- A build log note in the template that names the skipped-phase line the script accepts.
- Two tests, docs, and the version bump.

### Out of Scope
- A change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A change to `consistency-check.mjs`. It runs at P1, before phase blocks exist.
- A PowerShell twin of the script.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |
| Check run time | Under 1 second on a 200-line build log | Test run |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.

### Assumptions
- Build log timestamps use ISO-8601 UTC, as the template and every archived log show. Impact if wrong: the check reports a timestamp it cannot read, and ship stops. The test covers this case.

## Scenario Paths

**Happy path:** A complete build log passes, and ship archives.

> The script prints `build-log-check: clean` and exits 0.

**Alternative path:** A phase has no block and the log marks it with a `Skipped: P{n}` line.

> The script accepts the missing block.

**Error / sad path:** A block has a blank `End`, or a `Wall clock` of `0` against a two-minute span.

> The script exits 1 and names the phase. Ship fixes the block and reruns.

**Cross-session continuity:** A resumed run rewrites the build log.

> The check reads the file as it stands, so a resumed log gets the same result.

## Acceptance Criteria

- [ ] The ship skill holds `gh pr merge --squash --delete-branch {n}`, says `{n}` is a literal number, and forbids substitution on the line.
- [ ] `merge-guard` allows that line with a literal number for an `initiative/*` base, and its source and tests are unchanged.
- [ ] `build-log-check.mjs` fails and names the phase for a blank `End`, a blank `Wall clock`, and a wall clock that differs by more than one minute.
- [ ] The script fails for a missing block that the log does not mark skipped, and for a `Total wall clock` of `not recorded`. A complete log passes.
- [ ] The ship skill runs the script before Archive, and stops on a failure.
