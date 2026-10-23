# Execution Plan - autonomous-mode-and-prefixes

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Version:** 0.9.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | | No capability skill applies |

## Functional Requirements Directory

Each file follows the naming convention `req-{NNN}-{kebab-slug}.md` and the [Requirement Template](../../planifest-zero/templates/requirement.template.md).

| File | Requirement | Source | Points |
|------|------------|--------|--------|
| [req-001-run-mode-question.md](requirements/req-001-run-mode-question.md) | The run-mode question and `plan/.run-mode` values `gated` and `autonomous` | US-001, US-002 | 4 (REQ-001 to REQ-003) |
| [req-002-gate-and-exception-stops.md](requirements/req-002-gate-and-exception-stops.md) | Gate stops per mode and the four exception stops | US-001, US-002 | |
| [req-003-run-mode-resume.md](requirements/req-003-run-mode-resume.md) | Resume with a missing or unknown run mode | US-001, US-002 | |
| [req-004-phase-numbers-p0-to-p4.md](requirements/req-004-phase-numbers-p0-to-p4.md) | Phases P0 to P4 and the build-log headings | US-003 | 4 (REQ-004 to REQ-006) |
| [req-005-message-prefixes.md](requirements/req-005-message-prefixes.md) | The five message prefixes and one status form | US-003 | |
| [req-006-phase-guard-and-stale-cites.md](requirements/req-006-phase-guard-and-stale-cites.md) | Stale cites, the `custom-004` rename, and the guard test | US-003 | |
| [req-007-product-name-planifest-zero.md](requirements/req-007-product-name-planifest-zero.md) | `name: "Planifest Zero"` in both manifests | US-004 | 1 |
| [req-008-framework-prose.md](requirements/req-008-framework-prose.md) | No prose describes Planifest Zero as a framework | US-005 | 4 (REQ-008 to REQ-010) |
| [req-009-framework-identifiers.md](requirements/req-009-framework-identifiers.md) | Identifier and file renames per ADR-004 | US-005 | |
| [req-010-framework-allowlist-test.md](requirements/req-010-framework-allowlist-test.md) | The allowlist grep test | US-005 | |

The consistency check allows three acceptance criteria per requirement, so each story group splits into several files. The points stay with the group.

## Implementation order

Several requirements edit the same files, so P2 runs them in this order:

1. REQ-004 to REQ-006 renumber every phase cite. Later requirements then edit text that already uses the new numbers.
2. REQ-001 to REQ-003 and REQ-007 run in parallel. REQ-007 touches only the two manifests and a new test.
3. REQ-008 to REQ-010 run last. They reword prose, rename identifiers per ADR-004, and add the allowlist test.

Inside REQ-008 and REQ-009, subagents split by directory so no two edit one file.

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Consistency | Phase cites stay inside P0 to P4 | 0 cites of P5 to P9 or a letter prefix outside history | Grep guard test from REQ-006 |
| NFR-002 | Consistency | "Framework" never names Planifest Zero | 0 lines outside the allowlist and history | Allowlist test from REQ-010 |
| NFR-003 | Reliability | The full suite passes | 0 failures in `run-tests.sh` and `run-tests.ps1` | CI on the pull request |
| NFR-004 | Security | An unmitigated critical or high finding stops an autonomous run | Stop in 100% of cases | REQ-002 test asserts the stop rule in the validate-and-accept skill |

## API Summary

Not applicable. Planifest Zero exposes no API.

## Data Model Summary

| Entity | Owner Component | Key Fields | Relationships |
|--------|----------------|------------|--------------|
| `plan/.run-mode` | planifest-zero (orchestrator skill) | one value: `gated` or `autonomous` | Read by every phase skill |
| `plan/current/build-log.md` | planifest-zero (orchestrator skill) | `### P<n>: {Phase Name}` blocks, n from 0 to 4 | Each phase skill appends its own block |

## Component Interactions

```mermaid
flowchart LR
    O[orchestrator] -->|writes| R[plan/.run-mode]
    O -->|invokes| P1[P1 plan]
    P1 --> P2[P2 implement]
    P2 --> P3[P3 validate and accept]
    P3 --> P4[P4 ship]
    P1 & P2 & P3 & P4 -->|read| R
    P4 -->|gh pr create| G[GitHub]
```

## Assumptions

Each is a risk item with likelihood: medium.

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-003 | No other repo installs Planifest Zero. | Another install breaks on the renamed identifiers and run-mode values. |
| A-004 | Tests keep names that carry old feature ids, unless the name calls Planifest Zero a framework. | A name such as `continuous-run-p1-p3` misleads a reader. |

## Open Questions

None. The human answered every fork in discovery.
