---
title: "Risk Register - setup-cleanup-and-park-hardening"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.8.0"
---
# Risk Register - setup-cleanup-and-park-hardening

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Version:** 0.8.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | `pwsh` is missing on this machine, so the PowerShell suite skips locally (REQ-002, REQ-003). Only CI proves the PowerShell changes. | high | medium | CI runs the PowerShell suite before acceptance. | open |
| R-002 | technical | The non-array warning text in the two setup scripts drifts apart (REQ-003). | low | low | Parity tests assert the exact line in both suites. | open |
| R-003 | technical | The two `park.mjs` copies drift apart (REQ-004). | low | medium | P4 reruns setup to refresh the installed copy, then checks the two copies with `diff`. | open |
| R-004 | security | A hook value that holds a secret reaches the terminal through the non-array warning (REQ-003). | low | high | The warning drops the old value. Tests assert the exact stderr lines and that a planted secret never appears. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A failing `pre-commit` hook in a temporary repo forces the chore commit to fail. | The park test needs another way to fail the commit, such as a read-only index. | open |
| A-002 | The PowerShell reading of 0000128 is correct, though nobody has run it. | The new test passes before the fix, so the test writer must confirm RED in CI. | open |
