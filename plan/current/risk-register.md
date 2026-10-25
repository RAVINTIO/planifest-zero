---
title: "Risk Register - explain-strict-mode"
summary: "One technical risk and one logged assumption, with their mitigations."
status: "draft"
version: "0.18.1"
---
# Risk Register - explain-strict-mode

**Skill:** plan
**Feature:** 0000185-explain-strict-mode
**Version:** 0.18.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The new text drifts from what `check-orchestrator-presence.mjs` does. | low | low | Discovery read the hook. P3 verification checks each claim against it. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The anchor `#strict-orchestrator-mode` stays stable because the heading text stays the same. | The two links break, and the suite fails. | open |
