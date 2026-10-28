---
title: "Risk Register - boot rules into skills"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - boot rules into skills

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Version:** 0.34.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A targeted override block doubles in the installed skill on a rerun | medium | medium | Remove the marker block before each append, with a two-run test | open |
| R-002 | security | A crafted `target:` value writes outside the skills directory | low | high | Allow only `^[a-z0-9][a-z0-9-]*$` naming an installed folder, with a traversal test | open |
| R-003 | operational | Tests that read the boot text or override files fail after the move | high | low | Update expected locations and log each as rework | open |
| R-004 | operational | The bash and PowerShell installs drift apart | medium | medium | Mirror each change and run the parity suites | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A pack skill installs as `{skills dir}/{name}/SKILL.md` | The append path fails and setup falls back to the boot file | open |
| A-002 | Step 4 (0000242) already set the pack-only size cap | The cap needs a second edit | open |
