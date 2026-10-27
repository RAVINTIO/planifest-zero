# Requirement: REQ-002 - ship and delivery hooks, and the P0 and chart reads

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Source:** US-001, US-002, US-004
**Priority:** must-have

## User Story

As the human on the loop, I see ship and delivery write the retrospectives, and P0 discovery and initiative charting read the latest ones, so that past lessons shape the next plan.

## Functional Requirements
- `ravintio-zero/skills/ravintio-ship/SKILL.md` Step 5 runs `ravintio-retrospective` in run mode after the build report, and the report lists the record by path.
- `ravintio-zero/standards/roadmap-standards.md` I-E Delivery runs `ravintio-retrospective` in initiative mode after the archive and before the PR. The PR body lists the record.
- Discovery Start Actions step 11 in the orchestrator skill adds a scan of the latest retrospectives in `plan/retrospectives/` to `discovery.md`. If none exist, `discovery.md` says so.
- `roadmap-standards.md` I-A Chart reads the latest retrospectives before it coaches the human.
- The orchestrator skills catalogue has a row for the skill.
- The ship step and the delivery step never block on a missing retrospective.

## Acceptance Criteria
- [ ] AC-1: ship writes the run retrospective
  - Given the ship skill
  - When a test reads Step 5
  - Then it names `ravintio-retrospective`, run mode, and `plan/retrospectives/`
- [ ] AC-2: delivery writes the initiative retrospective
  - Given the roadmap standards
  - When a test reads I-E Delivery
  - Then it runs initiative mode after the archive and before the PR, and the PR body lists the record
- [ ] AC-3: P0 and chart read past records
  - Given the orchestrator skill and the roadmap standards
  - When a test reads Discovery Start Actions step 11 and I-A Chart
  - Then both name `plan/retrospectives/`, and the catalogue has a row for the skill

## Dependencies
- REQ-001
