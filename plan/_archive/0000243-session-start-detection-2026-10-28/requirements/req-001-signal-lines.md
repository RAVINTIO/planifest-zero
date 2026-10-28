---
title: "Requirement: REQ-001 - The script prints one fixed line per resume signal"
summary: "The script prints one fixed line per resume signal"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - The script prints one fixed line per resume signal

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want a script that prints one fixed line per resume signal, so that tests cover what the agent reads.

## Functional Requirements
- `ravintio-zero/scripts/resume-detect.mjs` takes the project directory as its first argument.
- It prints one line per finding for each of the 12 checks.
- It exits 0 and writes nothing.

## Acceptance Criteria
- [ ] AC-1: each check has a line
  - Given a fixture that holds the signal of one of the 12 checks
  - When the script runs on it
  - Then it prints that check's line
- [ ] AC-2: absent signal
  - Given a fixture without that signal
  - When the script runs on it
  - Then it does not print that check's line

## Dependencies
- None
