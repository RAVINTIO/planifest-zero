# Risk Register - improvement loops

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Version:** 0.24.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | Each cycle adds a reviewer dispatch and a suite run to every requirement | high | low | The cap is 2 cycles and an empty finding stops the loop at once. | open |
| R-002 | technical | An applied change alters behaviour | low | medium | The refactor hard limits stay in force. The full suite must pass or the change is reverted. | open |
| R-003 | operational | The reviewer always finds something and the loop churns | medium | low | The reviewer brief says to report only a change worth making. The cap of 2 bounds the churn. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A reviewer in a fresh context gives an independent read | Cycles find nothing and stop early, which costs one dispatch | open |
