# Execution Plan - chart rules

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000252-chart-rules
**Version:** 0.40.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-guard-widening-rule.md](requirements/req-001-guard-widening-rule.md) | Chart names the guard and the new forms when an entry widens a fail-closed hook, and needs a separate approval |
| [req-002-step-confirmation-rule.md](requirements/req-002-step-confirmation-rule.md) | Chart lists each step confirmation and records a pre-approval or plans a human stop |
| [req-003-p1-skip-record.md](requirements/req-003-p1-skip-record.md) | Chart records whether each step may skip P1, and a step with no yes row stops |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Pack skill text stays under its cap | 1,720 lines or fewer | `test-0000031-req-003-five-phases.sh` |
| NFR-002 | Size | The orchestrator `SKILL.md` stays under its cap | 9,000 bytes or fewer | `test-0000151-req-011-orchestrator-references-split.sh` |
| NFR-003 | Correctness | No hook file changes | 0 changed paths under `ravintio-zero/hooks/` | `git diff --name-only` in P3 |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits Markdown files in one component, `ravintio-zero`. The driver counts rows under `## Steps` only, so the new `## P1 skips` section does not reach it.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edit to `ravintio-initiative/SKILL.md`) | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh` | U-004 |
| Skill count (no skill added) | none found | none |
| Size cap on an edited skill (the initiative skill has no cap test) | none found | none |
| Pulled-in entry ids 0000223, 0000225, 0000234 | none found | none |
| Edit to the initiative skill | `test-0000205-req-004-initiative-skill.sh`, `test-0000240-req-002-activity-lines.sh`, `test-0000250-req-001-routing-and-restart-rules.sh` | U-004 |
| Edit to `roadmap-standards.md` | `test-0000043-req-002-roadmap-chart.sh`, `test-0000043-req-009-roadmap-resume-and-prefixes.sh`, `test-0000151-req-014-chart-clarity-and-dependency-stop.sh`, `test-0000205-req-005-living-docs-and-counts.sh`, `test-0000206-req-001-chart-rules.sh`, `test-0000189-req-003-initiative-prefixes.sh` | U-001, U-002, U-003 |
| Edit to `initiative.template.md` | `test-0000189-req-004-initiative-states.sh`, `test-0000206-req-001-chart-rules.sh`, `test-0000199-req-001-003-reserve-ids-from-counter.sh`, `test-0000043-req-011-chart-time-schema-approval.sh` | U-002, U-003 |
| Edit to the Phase Skip Protocol reference | `test-0000151-req-011-orchestrator-references-split.sh` | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/tests/test-0000252-req-001-guard-widening-rule.sh` | 1 | Three units edit one standards file, so they run in order |
| U-002 | U-001 | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/templates/initiative.template.md`, `ravintio-zero/tests/test-0000252-req-002-step-confirmation-rule.sh` | 2 | Shares the standards file with U-001 |
| U-003 | U-002 | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/templates/initiative.template.md`, `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-session-commands.md`, `ravintio-zero/tests/test-0000252-req-003-p1-skip-record.sh` | 3 | Shares the standards file and the template with U-002 |
| U-004 | U-003 | `ravintio-zero/skills/ravintio-initiative/SKILL.md` | 4 | Names the final text of all three rules |
| U-005 | U-004 | `ravintio-zero/component.yml`, `docs/`, `plan/changelog/` | 5 | Documents the final text |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The driver reads only the `## Steps` table of `initiative.md` | A new section breaks the step count, and the driver test fails |

## Open Questions

None.
