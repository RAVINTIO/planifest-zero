---
title: "Risk Register - workflow-governance-gates"
summary: "Technical risks and one logged assumption, with their mitigations."
status: "draft"
version: "0.18.0"
---
# Risk Register - workflow-governance-gates

**Skill:** plan
**Feature:** 0000173-workflow-governance-gates
**Version:** 0.18.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A prose mention of `Blocked:` in the build log counts as a stop. Relates to the marker lines in the scope. | medium | low | The script counts a marker only at the start of a line or list item, outside fenced code. | open |
| R-002 | technical | The skill size budgets fail when the marker rules land in `SKILL.md` files. Relates to the implement and validate skill changes. | medium | low | Keep each skill addition to one or two lines and point at the standard. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Agents write the marker lines when the skill text tells them to. | The metrics read low. The report states that each count comes from markers only. | open |
