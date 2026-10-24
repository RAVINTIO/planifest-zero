# Execution Plan - ravintio-rebrand

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** plan
**Feature:** 0000160-ravintio-rebrand
**Version:** 1.0.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | | No capability skill applies |

## Decisions referenced

| ADR | Decision |
|-----|----------|
| ADR-001 | The brand and identifier rename map |
| ADR-002 | Legacy aliases stay accepted through 1.x |
| ADR-003 | Consumers upgrade through migration 0004 and its helpers |
| ADR-004 | A guard test blocks the old brand outside history |

## Functional Requirements Directory

| File | Requirement | Source |
|------|------------|--------|
| [req-001-pack-identifiers.md](requirements/req-001-pack-identifiers.md) | Rename folders, skills, files, and ids | US-001 |
| [req-002-runtime-names.md](requirements/req-002-runtime-names.md) | Hooks, setup, scripts, and CI use the new names | US-002 |
| [req-003-environment-variables.md](requirements/req-003-environment-variables.md) | `RAVINTIO_*` variables with two roadmap fallbacks | US-003 |
| [req-004-brand-prose.md](requirements/req-004-brand-prose.md) | RAVINTIO Zero in all prose and links | US-004 |
| [req-005-consumer-migration.md](requirements/req-005-consumer-migration.md) | Migration 0004 and its two helpers | US-005 |
| [req-006-brand-guard.md](requirements/req-006-brand-guard.md) | Guard test with an allowlist | US-006 |

## Build order

The rename touches nearly every file, so the requirements cannot all start at once.

1. **Batch 1, sequential:** one scripted pass does the mechanical part of REQ-001 to REQ-004.
   - It moves every path with `git mv`.
   - It replaces tokens in tracked files outside history, longest token first.
   - It uses byte-exact tools.
   - It then runs the full suite to confirm nothing broke.
2. **Batch 2, parallel:** four TDD tracks work on disjoint files.
   - REQ-002 adds the leftover-folder stop, the marker cleanup, and the sentinel alias. It works in setup and the hooks.
   - REQ-003 adds the roadmap fallback. It works in `roadmap-run.mjs`.
   - REQ-005 adds the migration and its helpers. It works in `migrations/`.
   - REQ-006 adds the guard test. It works in `tests/`.
3. **Batch 3, sequential:** a prose review fixes grammar the token pass left. Then the living docs update.

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Correctness | Residual old brand outside history and the allowlist | 0 lines, 0 paths | REQ-006 guard test |
| NFR-002 | Regression | Existing suites on every shell | All pass on Bash, Windows PowerShell 5.1, and PowerShell 7 | CI matrix |

## API Summary

Not applicable. The pack exposes no API.

## Data Model Summary

Not applicable. No component owns data.

## Component Interactions

```mermaid
flowchart LR
    C[Consumer repo] -->|copies| P[ravintio-zero pack]
    P -->|setup| I[.claude install]
    P -->|migration 0004| C
```

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Sibling repos keep their repo names after the org rename | README links to them need a follow-up edit |

## Open Questions

None.
