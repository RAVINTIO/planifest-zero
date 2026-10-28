---
title: "Risk Register - session start detection"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - session start detection

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Version:** 0.32.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | Hook output carries repo text and a hostile commit plants instructions | low | high | The script prints fixed text only, and a test plants text in `pause.md` and the build log | open |
| R-002 | technical | The script fails and the failure reads as no signals | low | medium | The hook injects `resume detection did not run`, and a test forces a failure | open |
| R-003 | technical | The skill line cap has 35 lines of headroom | medium | low | The new rule is shorter than the old section | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The 12 checks stay the source of the order | The order test fails and shows it | open |
