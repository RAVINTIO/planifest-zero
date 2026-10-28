---
title: "Risk Register - watcher false events"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - watcher false events

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Version:** 0.31.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A branch-change line hides a run of real new commits | low | low | The next pass lists commits from the recorded `HEAD` | open |
| R-002 | security | The new `git merge-base` call takes a sha from watcher state | low | low | Use an argument array, and accept only 40-character hex shas from `git log` | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The heartbeat already reads the lock file on each pass | The lock test fails and the fix goes in this step | open |
