---
title: "Requirement: req-009 - roadmap-resume-and-prefixes"
summary: "Resume detection checks the active roadmap before plan/current, and R-A to R-E prefixes sit beside P0 to P4."
status: "draft"
version: "0.1.0"
---
# Requirement: req-009 - roadmap-resume-and-prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-004, US-007
**Priority:** must-have

## User Story

As a human on the loop, I let each roadmap step start or resume on its own and report in a known prefix, so that the chain runs without me and I can follow it.

## Functional Requirements
- Resume Detection in the orchestrator checks `plan/current-roadmap/` before it scans `plan/current/`.
  - If a roadmap is `active` and `plan/current/` holds artifacts, resume that step through normal resume detection.
  - If a roadmap is `active` and `plan/current/` is empty, start the step at `position`.
  - If no roadmap is `active`, resume detection behaves as it does today.
- The orchestrator's "Phases and Response Prefixes" section and `planifest-zero/pipeline-reference.md` list the roadmap prefixes beside P0 to P4:
  - `R-A Chart:`
  - `R-B Activate:`
  - `R-C Run:`
  - `R-D Advance:`
  - `R-E Delivery:`
- Both sets use the form `{prefix} {Status}: {one-liner}`.
- Both files state that R-A to R-E are stage letters, not phase numbers, so Hard Limit 10 still holds.
  - Hard Limit 10 keeps its text: five phases, P0 to P4.
  - Existing checks for retired letter prefixes and phase numbers above P4 still pass.

## Acceptance Criteria
- [ ] (a) Resume Detection in the orchestrator names `plan/current-roadmap/` and checks it before `plan/current/`, with both the "artifacts resume that step" case and the "empty starts at `position`" case.
- [ ] (b) The orchestrator and `pipeline-reference.md` each list all five `R-` prefixes, state the `{prefix} {Status}: {one-liner}` form for both sets, and say the R-A to R-E labels are stage letters, not phase numbers.
- [ ] (c) `test-0000042-req-004-phase-numbers-p0-to-p4.sh`, `test-0000042-req-005-message-prefixes.sh`, and `test-0000042-req-006-phase-guard-and-stale-cites.sh` still pass, and Hard Limit 10 still reads "exactly five phases, P0 to P4".

## Dependencies
- REQ-007 supplies the driver whose fresh sessions rely on the "empty `plan/current/` starts at `position`" rule.
- The 0000042 phase guard and prefix tests are the existing checks that the new prefixes must not trip.
  - The guard pattern blocks `P5` to `P9`, `Phase <n>`, and the letters `D:`, `PL:`, `IM:`, `VA:`, and `SH:`. `R-D Advance:` does not match it.
  - The prefix test reads the orchestrator's "Phases and Response Prefixes" section and the pipeline reference's "Phase Indicators" section. A new `R-` table in those sections must keep the one status form.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` (Resume Detection, "Phases and Response Prefixes", Hard Limit 10)
  - `planifest-zero/pipeline-reference.md` ("Phase Indicators")
  - `planifest-zero/tests/test-0000043-req-009-roadmap-resume-and-prefixes.sh` (new)
  - `planifest-zero/tests/test-0000042-req-004-phase-numbers-p0-to-p4.sh` (existing guard, run unchanged)
  - `planifest-zero/tests/test-0000042-req-005-message-prefixes.sh` (existing guard, run unchanged)
  - `planifest-zero/tests/test-0000042-req-006-phase-guard-and-stale-cites.sh` (existing guard, run unchanged)
