---
title: "Roadmap: 0000168 - backlog clearance"
summary: "Clears the six open backlog entries in five feature releases, plus a docs fix as step 6."
status: "active"
---
# Roadmap: 0000168 - backlog clearance

**Goal:** Clear every open backlog entry from 2026-10-25, one feature release per step. The evaluation suite split from 0000100 stays in the backlog as 0000174.
**Branch:** roadmap/0000168-backlog-clearance
**Status:** active
**Position:** 4

The human charted this roadmap and confirmed it on 2026-10-25. The confirmation sharpened backlog entries 0000159, 0000110, and 0000100 with a **Wanted outcome** section each.

On 2026-10-25, during step 4, the human added step 6 to explain strict mode and its acknowledgement file (backlog 0000184).

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a step PR.
- A step proposes a destructive change.

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1 | none | none | none |
| 2 | none | none | none |
| 3 | none | none | none |
| 4 | none | none | none |
| 5 | none | none | none |
| 6 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1 | none | none | none |
| 2 | none | none | none |
| 3 | none | none | none |
| 4 | none | none | none |
| 5 | none | none | none |
| 6 | none | none | none |

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000169-release-hygiene | 0000166, 0000167 | minor | 0.14.0 | merged |
| 2 | 0000170-story-mapping-and-gherkin | 0000165 | minor | 0.15.0 | merged |
| 3 | 0000171-faster-setup-ps1-tests | 0000159 | minor | 0.16.0 | merged |
| 4 | 0000172-subagent-acceleration | 0000110 | minor | | pending |
| 5 | 0000173-workflow-governance-gates | 0000100 | minor | | pending |
| 6 | 0000185-explain-strict-mode | 0000184 | patch | | pending |
