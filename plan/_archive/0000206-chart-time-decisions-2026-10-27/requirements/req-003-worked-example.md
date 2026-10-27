# Requirement: REQ-003 - worked example replaying roadmap 0000168

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Version:** 0.28.0
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As the human on the loop, I see the four roadmap 0000168 step 3 stops answered by table rows, so that I know the rules would have prevented them.

## Functional Requirements
- The Chart-time decisions section holds a worked example with one row for each of the four stops: profile on Windows after CI missed the target, widen scope to drop skill bundling, raise the bump to minor, and measure the speed target per case.
- Each row gives the fork, the pre-approved answer, and the bump effect.
- The example also shows the baseline row and the criterion row that would have caught the per-case measure.

## Acceptance Criteria
- [ ] AC-1: the example answers all four stops
  - Given the Chart-time decisions section
  - When a test reads the worked example
  - Then it holds four rows that name profile on Windows, drop skill bundling, raise the bump, and measure per case

## Dependencies
- REQ-001
