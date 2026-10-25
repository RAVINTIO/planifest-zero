---
title: "Risk Register - subagent-acceleration"
summary: "Technical and operational risks, and one logged assumption, with their mitigations."
status: "draft"
version: "0.17.0"
---
# Risk Register - subagent-acceleration

**Skill:** plan
**Feature:** 0000172-subagent-acceleration
**Version:** 0.17.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A fast batch dispatches two units that write the same file. Relates to REQ-002 and ADR-003. | medium | medium | The dispatch standards require disjoint write sets within a batch. The cannot-parallelise list still applies. | open |
| R-002 | operational | A new sentinel file, `plan/.run-speed`, reaches a roadmap branch. Relates to REQ-001 and ADR-002. | low | low | The ship skill deletes `plan/.run-speed` with the other sentinels. A test checks the deletion. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Phase agents follow a listed fast batch more reliably than a general rule. | Fast runs dispatch no more agents than standard runs. The build report shows the agent count, so the gap is visible. | open |
