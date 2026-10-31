# Execution Plan - initiative mid-run changes

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000250-initiative-mid-run-changes
**Version:** 0.39.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-routing-and-restart-rules.md](requirements/req-001-routing-and-restart-rules.md) | The initiative skill routes a mid-run repo instruction into step scope and restarts the driver on the restart stop |
| [req-002-driver-restart-stop.md](requirements/req-002-driver-restart-stop.md) | The driver stops after a merged step that changed the driver, the watcher, or the initiative skill, and names the files |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Pack skill text stays under its cap | 1,720 lines or fewer | `test-0000031-req-003-five-phases.sh` |
| NFR-002 | Correctness | A step that changes none of the three files gives no restart | 0 restarts | `test-0000250-req-002-driver-restart-stop.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits the driver, one skill, and one standards file in one component, `ravintio-zero`. The driver adds two `git` calls with argument arrays and no shell.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edit to `ravintio-initiative/SKILL.md`) | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh` | U-001 |
| Skill count (no skill added) | none found | none |
| Size cap on an edited skill (the initiative skill has no cap test) | none found | none |
| Pulled-in entry ids 0000226 and 0000227 | none found | none |
| Edit to the initiative skill | `test-0000205-req-004-initiative-skill.sh`, `test-0000205-req-007-stage-ownership.sh`, `test-0000205-req-005-living-docs-and-counts.sh`, `test-0000240-req-002-activity-lines.sh`, `test-0000218-req-001-002-skill-owner-banner.sh` | U-001 |
| Edit to the driver | `test-0000043-req-007-roadmap-driver.sh`, `test-0000205-req-001-driver-fixes.sh`, `test-0000205-req-006-driver-final-report.sh`, `test-0000151-req-012-roadmap-step-logs.sh`, `test-0000240-req-001-driver-stream-args.sh` | U-002 |
| Edit to `roadmap-standards.md` | `test-0000205-req-005-living-docs-and-counts.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000189-req-003-initiative-prefixes.sh` | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/skills/ravintio-initiative/SKILL.md`, `ravintio-zero/tests/test-0000250-req-001-routing-and-restart-rules.sh` | 1 | Two short edits, so one inline context costs less than a subagent |
| U-002 | none | `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/tests/test-0000250-req-002-driver-restart-stop.sh` | 1 | Two short edits, so one inline context costs less than a subagent |
| U-003 | U-001, U-002 | `ravintio-zero/standards/roadmap-standards.md` | 2 | Documents the final text of both units |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The initiative branch ref moves when a step merges | The check sees no change, and the existing "not merged" stop applies |

## Open Questions

None.
