# Execution Plan - ship merge command and wall clock check

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Version:** 0.37.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-plain-merge-command.md](requirements/req-001-plain-merge-command.md) | The ship skill and I-D Advance give a plain merge line with a literal PR number |
| [req-002-build-log-wall-clock-check.md](requirements/req-002-build-log-wall-clock-check.md) | `build-log-check.mjs` fails a blank or wrong phase time, and ship runs it before Archive |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Pack skill text stays under its cap | 1,720 lines or fewer | `test-0000031-req-003-five-phases.sh` |
| NFR-002 | Performance | The check reads a 200-line build log quickly | Under 1 second | Test run |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits files in one component, `ravintio-zero`. Ship Step 3 calls `build-log-check.mjs` on `plan/current/build-log.md`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edit to `ravintio-ship/SKILL.md`) | `test-0000031-req-003-five-phases.sh` | U-002 |
| Skill count (no skill added) | none found | none |
| Size cap on an edited skill (ship has no cap test) | none found | none |
| Pulled-in entry ids 0000228, 0000232 | none found | none |
| Edit to ship Step 3 | `test-0000172-req-003-phase-timing.sh`, `test-0000006-build-assessment.sh` | U-002 |
| Edit to the ship Initiative steps section | `test-0000043-req-010-merge-carve-out-governance.sh`, `test-0000025-req-002-ship-agent-p7-git-add.sh` | U-002 |
| Edit to I-D Advance step 4 | `test-0000043-req-005-roadmap-advance.sh` | U-002 |
| Edit to `build-log.template.md` | `test-0000172-req-003-phase-timing.sh` | U-001 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/scripts/build-log-check.mjs`, `ravintio-zero/templates/build-log.template.md`, `ravintio-zero/tests/test-0000248-req-002-build-log-wall-clock-check.sh` | 1 | The ship skill step in U-002 names the script, so the script lands first |
| U-002 | U-001 | `ravintio-zero/skills/ravintio-ship/SKILL.md`, `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/tests/test-0000248-req-001-plain-merge-command.sh` | 2 | It edits the ship skill after the script exists, and the units are small enough for one context |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Build log timestamps use ISO-8601 UTC | The check reports an unreadable timestamp and ship stops |

## Open Questions

None.
