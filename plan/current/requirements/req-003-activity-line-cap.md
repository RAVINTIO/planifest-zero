---
title: "Requirement: REQ-003 - Activity lines stay within 200 characters"
summary: "Activity lines stay within 200 characters"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Activity lines stay within 200 characters

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want each summary line short, so that my chat stays readable.

## Functional Requirements
- The whole printed line, prefix included, is 200 characters or fewer.
- The watcher keeps the first line of any multi-line detail and replaces control characters with a space.

## Acceptance Criteria
- [ ] AC-1: long input is cut
  - Given a `tool_use` whose command is 1,000 characters long
  - When the watcher prints its activity line
  - Then the line is 200 characters or fewer and starts `I-C Run: activity: tool: Bash`
- [ ] AC-2: multi-line detail
  - Given a Bash command with a newline
  - When the watcher prints its line
  - Then the line holds one physical line

## Dependencies
- REQ-002
