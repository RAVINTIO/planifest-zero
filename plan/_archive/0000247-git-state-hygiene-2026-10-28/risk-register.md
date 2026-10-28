---
title: "Risk Register - git state hygiene"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - git state hygiene

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Version:** 0.36.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The skill additions push pack skill text past 1,720 lines | low | medium | The pack holds 1,509 lines and the additions run to 10 or fewer | open |
| R-002 | technical | The orchestrator rule pushes `SKILL.md` past 9,000 bytes | low | medium | It holds 7,985 bytes and the rule runs to about 250 | open |
| R-003 | technical | `--commit` sweeps other staged files into the counter commit | low | medium | The script passes the path after `--`, and a test stages a second file | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `git commit -- plan/backlog/.next-id` commits that path alone | The commit holds extra files | open |
