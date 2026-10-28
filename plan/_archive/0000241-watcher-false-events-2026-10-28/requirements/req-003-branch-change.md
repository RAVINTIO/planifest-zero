---
title: "Requirement: REQ-003 - A branch switch prints one line"
summary: "A branch switch prints one line"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - A branch switch prints one line

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Source:** US-003
**Priority:** must-have

## User Story

As an initiative owner, I want a branch switch reported in one line, so that old commits do not appear as new events.

## Functional Requirements
- If the last-seen commit is an ancestor of `HEAD`, the watcher prints one commit line for each commit from `git log {last-seen}..HEAD`.
- If it is not an ancestor, or git does not know it, the watcher prints `I-C Run: event: branch changed to {branch}` once, prints no commit lines, and records `HEAD`.
- `--passes {n}` is a test aid that runs n passes in one process with `--once`.

## Acceptance Criteria
- [ ] AC-1: branch switch
  - Given a last-seen commit on another branch and a `HEAD` that holds 100 older commits
  - When the watcher runs a pass
  - Then it prints one branch-change line and no commit lines
- [ ] AC-2: ordinary new commit
  - Given a last-seen commit that is an ancestor of `HEAD`
  - When the watcher runs a pass
  - Then it prints one commit line for each newer commit

## Dependencies
- None
