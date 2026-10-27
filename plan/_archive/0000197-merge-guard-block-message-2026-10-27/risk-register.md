---
title: "Risk Register - merge-guard block message"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - merge-guard block message

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000197-merge-guard-block-message
**Version:** 0.20.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A message edit changes control flow and weakens the guard | low | high | The change edits strings only. The existing suite and a before-and-after block-set check prove the same exits. | open |
| R-002 | operational | A consumer matches the old message text | low | low | No pack file matches the text outside the tests that change with it. | open |
| R-003 | technical | A malformed real merge call shows the text reason | medium | low | The text says the segment is not a bare merge call, so it stays accurate. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Backlog line numbers are approximate | P2 locates each block by name | open |
