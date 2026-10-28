---
title: "Risk Register - split the orchestrator skill"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - split the orchestrator skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000244-split-orchestrator-skill
**Version:** 0.33.0
**Overall Risk Level:** low

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A moved rule goes unread because its Pack Index trigger is vague | medium | medium | Each row names a concrete moment, and the no-lost-line check proves no line is lost | open |
| R-002 | technical | Some of the 39 tests that read `SKILL.md` fail after the move | high | low | Plan lists them up front and implement updates each to read the three locations | open |
| R-003 | technical | The 9,000 byte target is missed after the index rows are added | medium | medium | Measure after each move. Shorten index triggers before any other cut | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Each moved section is read only at its trigger | A session misses a rule until it reads the reference | open |
