---
title: "Risk Register - chart rules"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - chart rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000252-chart-rules
**Version:** 0.40.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The skill additions push pack skill text past 1,720 lines | low | medium | The pack holds 1,540 lines and the additions run to about 10 | open |
| R-002 | operational | An initiative charted before this release has no `## P1 skips` section, so a step that skips P1 stops | high | low | A missing table counts as an empty one, and the stop line names the fix | open |
| R-003 | security | The guard wording is read as a change to a hook | low | medium | The rule adds chart text only, and a test checks that no file under `ravintio-zero/hooks/` changes | open |
| R-004 | technical | A new template section breaks the driver's step count | low | high | The driver counts rows under `## Steps` only, and the driver suites run unchanged | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The driver reads only the `## Steps` table of `initiative.md` | A new section breaks the step count, and the driver test fails | open |
