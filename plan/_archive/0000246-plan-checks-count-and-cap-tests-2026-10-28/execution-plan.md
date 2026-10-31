# Execution Plan - plan checks count and cap tests

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000246-plan-checks-count-and-cap-tests
**Version:** 0.35.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-test-impact-scan.md](requirements/req-001-test-impact-scan.md) | The plan skill and template carry the test impact scan |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Pack skill text stays under its cap | 1,720 lines or fewer | `test-0000031-req-003-five-phases.sh` |
| NFR-002 | Size | The scan section stays small | 15 lines or fewer | `test-0000246-req-001-test-impact-scan.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits files in one component, `ravintio-zero`. No interactions.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edit to `ravintio-plan/SKILL.md`) | `test-0000031-req-003-five-phases.sh` | U-001 |
| Skill count (no skill added) | none found | none |
| Size cap on an edited skill (plan skill has no cap test) | none found | none |
| Pulled-in entry id 0000210 | none found. `test-0000199-req-001-003` mentions 210 as a seed floor only | none |
| Template headings (edit to `execution-plan.template.md`) | `test-0000201-req-001-concurrency-section.sh` | U-001 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/skills/ravintio-plan/SKILL.md`, `ravintio-zero/templates/execution-plan.template.md` | 1 | none |
| U-002 | none | `ravintio-zero/tests/test-0000246-req-001-test-impact-scan.sh` | 1 | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The four test families in discovery are the ones the entry means | The scan misses a test |

## Open Questions

None.
