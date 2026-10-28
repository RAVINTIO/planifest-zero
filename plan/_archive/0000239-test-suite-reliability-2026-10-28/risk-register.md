---
title: "Risk Register - test suite reliability"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - test suite reliability

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Version:** 0.30.2
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A call to an undefined assert inside `$(...)` or after `&&` is not scanned | low | low | The guard covers the line-start form that suites use. The new suite checks it | open |
| R-002 | technical | An existing suite already calls an undefined `assert_*` and now fails | medium | medium | Run the full suite after the change. Fix the call, not the guard | open |
| R-003 | operational | The skip hides a real stale install during an initiative | low | low | The last initiative step refreshes the install and checks it | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Suites call assert helpers at the start of a line | A call in another position passes unseen | open |
