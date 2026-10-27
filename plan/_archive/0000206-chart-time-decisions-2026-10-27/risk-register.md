# Risk Register - chart-time decisions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Version:** 0.28.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A row is too broad and approves a fork that needs a human | medium | medium | A row names one fork. The human approves each row at Chart. | open |
| R-002 | operational | The skill text grows past its budget | medium | low | Each skill gets one line. The rules live in the standards file. A test counts the lines. | open |
| R-003 | operational | The driver running this initiative started before this step, so later steps keep the old stage rules | high | low | Steps 12 and 13 do not depend on the new rules. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Step sessions read `initiative.md` | A step cannot apply a row and stops, as today | open |
