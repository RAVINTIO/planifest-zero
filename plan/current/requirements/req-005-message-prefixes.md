---
title: "Requirement: req-005 - message-prefixes"
summary: "Every message starts with one of five phase prefixes and one status form, and the letter prefixes are retired."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - message-prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-003
**Priority:** must-have

## User Story

As a human on the loop, I read a phase number and name at the start of every message, such as `P2 Implement:`, so that I know where the run is without a legend.

## Functional Requirements

### Message prefixes
- Every message starts with one of these prefixes:

  | Phase | Prefix |
  |-------|--------|
  | P0 | `P0 Discovery:` |
  | P1 | `P1 Plan:` |
  | P2 | `P2 Implement:` |
  | P3 | `P3 Validate:` |
  | P4 | `P4 Ship:` |

- Messages use `P3 Validate:` while skills and the build log keep "Validate and Accept".
- Status messages use the form `{prefix} {Status}: {one-liner}`. The status is one of Starting, Resuming, Complete, Blocked, or Skipped. An example is `P1 Plan: Complete: 4 requirements, 2 ADRs`.
- The letter prefixes `D:`, `PL:`, `IM:`, `VA:`, and `SH:` are retired. No skill, doc, template, hook, or standard uses them.
- The orchestrator prefix table and the "Phase Indicators" section of `planifest-zero/pipeline-reference.md` both use the one status form. Today the orchestrator uses a colon after the status and the reference uses a comma.

## Acceptance Criteria
- [ ] (a) The orchestrator prefix table and `pipeline-reference.md` "Phase Indicators" list the same five prefixes and the same `{prefix} {Status}: {one-liner}` form with the five statuses.

## Dependencies
- REQ-004 renumbers the phases that these prefixes name.
- REQ-006 holds the guard test that blocks retired letter prefixes.
- The design section "Phase numbers and prefixes" fixes the prefix table.

## Files in reach

- `planifest-zero/skills/planifest-orchestrator/SKILL.md`
- `planifest-zero/pipeline-reference.md`
- Any skill, doc, template, hook, or standard that uses a retired letter prefix. The guard test in REQ-006 finds them.
