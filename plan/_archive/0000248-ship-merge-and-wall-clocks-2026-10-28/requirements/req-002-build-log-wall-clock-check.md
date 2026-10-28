---
title: "Requirement: REQ-002 - Build log wall clock check"
summary: "A script fails a build log with a blank or wrong phase time, and ship runs it before Archive."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Build log wall clock check

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see ship stop before archive when a phase block has a blank or wrong time, so that archived build logs always hold usable wall clocks.

## Functional Requirements
- `ravintio-zero/scripts/build-log-check.mjs {build-log}` reads a build log. It exits 0 and prints `build-log-check: clean` when the log passes. It exits 1 and prints one finding per fault when it does not.
- Each finding names the phase. The faults are a blank `Start`, `End`, or `Wall clock`, a `Wall clock` more than one minute from `End` minus `Start`, an unreadable timestamp, and a missing block for P0 to P4.
- A missing block passes when the log holds a line `Skipped: P{n}`.
- A `Total wall clock` row that is blank or reads `not recorded` fails.
- Ship runs the script in Step 3, after the P4 `End` and `Wall clock` are filled and before Step 4 Archive, and stops on a failure.
- The build log template says how to mark a skipped phase.

## Acceptance Criteria
- [ ] AC-1: blank and wrong times fail
  - Given a build log with a blank `End`, a blank `Wall clock`, or a P0 block of `12:09:04Z` to `12:11:27Z` with `Wall clock` `0`
  - When the script reads it
  - Then it exits 1 and names the phase
- [ ] AC-2: missing block and total
  - Given a log with no P2 block and no `Skipped: P2` line, or a `Total wall clock` of `not recorded`
  - When the script reads it
  - Then it exits 1, and a `Skipped: P2` line makes the missing block pass
- [ ] AC-3: ship runs the check
  - Given the ship skill
  - When the test reads Step 3
  - Then it runs the script before Step 4 and stops on a failure, and a complete log from the template passes

## Dependencies
- none
