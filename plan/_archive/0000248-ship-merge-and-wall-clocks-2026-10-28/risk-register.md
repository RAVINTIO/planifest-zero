---
title: "Risk Register - ship merge command and wall clock check"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - ship merge command and wall clock check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Version:** 0.37.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The ship skill additions push pack skill text past 1,720 lines | low | medium | The pack holds 1,512 lines and the additions run to 10 or fewer | open |
| R-002 | technical | The check rejects a valid log from a resumed or skipped run | medium | low | The `Skipped: P{n}` line and the test fixtures cover the known shapes | open |
| R-003 | operational | A genuine P4 block fails because ship fills it after the check reads the file | low | medium | Step 3 fills the P4 `End` and `Wall clock` first and runs the check last | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Build log timestamps use ISO-8601 UTC | The check reports an unreadable timestamp and ship stops | open |
