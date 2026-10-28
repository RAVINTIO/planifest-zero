---
title: "Risk Register - driver step fixes"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - driver step fixes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Version:** 0.39.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite relies on the inherited step variable and fails once the runners clear it | low | low | The full suite runs under `RAVINTIO_INITIATIVE_STEP=1` and finds it | open |
| R-002 | operational | Attempt logs grow without bound across many re-runs | low | low | A re-run is rare and the folder is git-ignored. Pruning is out of scope | open |
| R-003 | security | The rotation follows a symlink and moves a file outside the log folder | low | medium | The rotation refuses a symlink at the folder, the step log, and the attempt path. A test covers each | open |
| R-004 | operational | The running driver predates this change, so a re-run of step 13 still truncates | high | low | The change applies after the human restarts the driver | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Renaming a file keeps its mode | The rotation sets mode 600 on the renamed file | open |
| A-002 | A suite that needs the step variable sets it for its own hook call | That suite fails once, and the step adds the setting | open |
