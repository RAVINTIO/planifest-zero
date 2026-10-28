---
title: "Requirement: REQ-005 - Skill relays activity lines and standards describe them"
summary: "Skill relays activity lines and standards describe them"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Skill relays activity lines and standards describe them

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Source:** US-003
**Priority:** must-have

## User Story

As an initiative owner, I want the initiative skill to relay each summary line, so that I see activity in my chat.

## Functional Requirements
- `ravintio-initiative/SKILL.md` tells the session to relay each `I-C Run: activity:` line to the human at once.
- `roadmap-standards.md` states that the step log holds stream-json events and names the activity line.
- The skill addition is 6 lines or fewer so the 1,720-line cap holds.

## Acceptance Criteria
- [ ] AC-1: skill relays
  - Given the initiative skill text
  - When it is searched for `I-C Run: activity:`
  - Then it tells the session to relay each such line to the human
- [ ] AC-2: standards updated
  - Given `roadmap-standards.md`
  - When the Step logs section is read
  - Then it names `stream-json` and the `activity` line

## Dependencies
- REQ-002
