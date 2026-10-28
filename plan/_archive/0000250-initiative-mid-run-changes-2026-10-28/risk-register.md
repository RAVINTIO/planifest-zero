---
title: "Risk Register - initiative mid-run changes"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - initiative mid-run changes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000250-initiative-mid-run-changes
**Version:** 0.39.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The skill additions push pack skill text past 1,720 lines | low | medium | The pack holds 1,530 lines and the additions run to about 12 | open |
| R-002 | operational | A false restart stops a run for no reason | low | low | The check covers three exact paths, and a test covers a step that changes none | open |
| R-003 | operational | The running driver predates this change and does not stop after step 12 | high | low | The build report tells the human to restart the driver before step 13 | open |
| R-004 | security | The routing rule is read as permission for the initiative session to write an override | low | medium | The rule says the session never writes the instruction, and `gate-write` stays unchanged | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The initiative branch ref moves when a step merges | The check sees no change, and the existing "not merged" stop applies | open |
