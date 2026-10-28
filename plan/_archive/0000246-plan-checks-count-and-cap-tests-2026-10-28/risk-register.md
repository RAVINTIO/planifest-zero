---
title: "Risk Register - plan checks count and cap tests"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - plan checks count and cap tests

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000246-plan-checks-count-and-cap-tests
**Version:** 0.35.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The addition pushes pack skill text past 1,720 lines, which fails `test-0000031-req-003` | low | medium | The section stays at 15 lines or fewer against 35 lines of headroom | open |
| R-002 | technical | The execution plan template change breaks a test that reads its headings | low | low | Run the template tests in P2 | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The four test families in discovery are the ones the entry means | The scan misses a test | open |
