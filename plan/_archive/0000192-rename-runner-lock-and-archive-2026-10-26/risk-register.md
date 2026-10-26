---
title: "Risk Register - rename-runner-lock-and-archive"
summary: "Two risks and one logged assumption for the runner lock and archive folder renames."
status: "draft"
version: "0.1.0"
---
# Risk Register - rename-runner-lock-and-archive

**Skill:** plan
**Feature:** 0000192-rename-runner-lock-and-archive
**Version:** 0.19.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A missed reference to the old lock leaves a driver that never releases its lock. | low | medium | The old-name guard flags the old lock name. The existing lock tests check release. | open |
| R-002 | technical | The delivery check misses an old archive folder and reruns a delivered initiative. | low | high | A driver test for each folder form. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | No driver runs while a consumer upgrades. | An old driver holding the old lock would not block a new driver for one upgrade window. | open |
