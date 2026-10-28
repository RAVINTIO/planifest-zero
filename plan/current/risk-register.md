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
| R-001 | technical | A suite with its own `command_not_found_handle` loses the guard | low | low | `grep` shows no suite sets one. The new suite checks the guard | open |
| R-002 | technical | An existing suite already calls an undefined `assert_*` and now fails | medium | medium | Run the full suite after the change. Fix the call, not the guard | open |
| R-003 | operational | The skip hides a real stale install during an initiative | low | low | The last initiative step refreshes the install and checks it | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `command_not_found_handle` runs in a forked child, so a counter is lost | The guard needs a file, and a test shows it works | open |
