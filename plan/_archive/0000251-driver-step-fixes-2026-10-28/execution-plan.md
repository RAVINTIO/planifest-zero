# Execution Plan - driver step fixes

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Version:** 0.39.1
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-runners-clear-step-variable.md](requirements/req-001-runners-clear-step-variable.md) | Both test runners clear `RAVINTIO_INITIATIVE_STEP` before any suite starts |
| [req-002-keep-attempt-logs.md](requirements/req-002-keep-attempt-logs.md) | The driver keeps every attempt log and names the attempt logs in a stop line |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Privacy | Attempt files and the log folder stay private | Folder mode 700, file mode 600 | `test-0000251-req-002-keep-attempt-logs.sh` |
| NFR-002 | Size | Pack skill text stays under its cap | 1,720 lines or fewer, no skill edited | `test-0000031-req-003-five-phases.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits the driver, both test runners, and one standards file in one component, `ravintio-zero`. The driver adds directory reads and one rename. It adds no process spawn.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (no `SKILL.md` edited) | none found | none |
| Skill count (no skill added) | none found | none |
| Size cap (no skill edited) | none found | none |
| Pulled-in entry ids 0000229 and 0000235 | none found | none |
| Edit to the driver | `test-0000043-req-007-roadmap-driver.sh`, `test-0000205-req-001-driver-fixes.sh`, `test-0000205-req-006-driver-final-report.sh`, `test-0000151-req-012-roadmap-step-logs.sh`, `test-0000240-req-001-driver-stream-args.sh`, `test-0000250-req-002-driver-restart-stop.sh` | U-002 |
| Edit to the runners | `test-0000036-req-001-003-runner.sh`, `regression/test-0000036-req-001-003-runner.sh`, `test-0000151-req-008-quiet-test-output.sh`, `test-0000151-req-008-quiet-test-output.ps1`, `test-0000171-req-003-timing-total.ps1`, `test-0000240-req-002-activity-lines.sh` | U-001 |
| Edit to `roadmap-standards.md` | `test-0000205-req-005-living-docs-and-counts.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000189-req-003-initiative-prefixes.sh`, `test-0000151-req-012-roadmap-step-logs.sh` | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/tests/run-tests.sh`, `ravintio-zero/tests/run-tests.ps1`, `ravintio-zero/tests/test-0000251-req-001-runners-clear-step-variable.sh` | 1 | Three short edits, so one inline context costs less than a subagent |
| U-002 | none | `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/tests/test-0000251-req-002-keep-attempt-logs.sh`, `ravintio-zero/tests/test-0000151-req-012-roadmap-step-logs.sh` | 1 | Three short edits, so one inline context costs less than a subagent |
| U-003 | U-001, U-002 | `ravintio-zero/standards/roadmap-standards.md` | 2 | Documents the final text of both units |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Renaming a file keeps its mode | The rotation sets mode 600 on the renamed file |
| A-002 | A suite that needs the step variable sets it for its own hook call | That suite fails once, and the step adds the setting |

## Open Questions

None.
