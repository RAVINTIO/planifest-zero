---
title: "Risk Register - PATH check before a missing-program claim"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - PATH check before a missing-program claim

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000249-check-path-before-missing-claims
**Version:** 0.38.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The skill additions push pack skill text past 1,720 lines | low | medium | The pack holds 1,526 lines and the additions run to 12 or fewer | open |
| R-002 | technical | The new status blurs the existing outcomes `verified`, `failed`, and `not-verifiable` | low | low | The skill lists it beside them, and the test checks its wording | open |
| R-003 | security | The recorded search output leaks environment values into a public PR | low | medium | The rule records the command and a found or not-found result, never raw output | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The three install folders in the entry cover the hosts that run this pack | A program in another folder reads as missing. The rule names them as examples of common paths | open |
