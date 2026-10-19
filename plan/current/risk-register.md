---
title: "Risk Register - setup-hardening-release-sizing"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.6.0"
---
# Risk Register - setup-hardening-release-sizing

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000039-setup-hardening-release-sizing
**Version:** 0.6.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Windows PowerShell 5.1 unwraps a one-item array when `setup.ps1` rebuilds `entry.hooks`. The single-object `hooks` fix adds a new place where this can happen. | medium | medium | Build arrays with `@()` and test on 5.1 in CI. | open |
| R-002 | security | A new error path prints file content. The invalid JSON handler is the likeliest place, because a parse error message can quote the text it failed on. | low | high | Print only the fixed line. Add planted-value cases that check stdout and stderr in both suites. | open |
| R-003 | operational | `pwsh` isn't installed locally, so only CI proves the `.ps1` suites. | medium | low | Open a draft PR early so CI runs during implement. | open |
| R-004 | compliance | This release scores 9 points against the `medium` budget of 8. The human confirmed the scope before the sizing rule existed. | low | low | Record the overrun in the build log. The human accepted the scope at P1 confirmation. | accepted |
| R-005 | technical | `setup.sh` and `setup.ps1` each hold their own copy of the filter rule. A single-object fix in one script can drift from the other. | medium | medium | Run both suites on the same single-object fixtures and compare the resulting entries. | open |
| R-006 | technical | `setup.ps1` calls `ConvertTo-Json -Depth 10` at several write sites, not only in the hook install step. Fixing one site leaves other writes that cut deep values. | medium | medium | List every `ConvertTo-Json` call that writes `settings.json` and set `-Depth 100` on each. Add the 15-level case for the hook install and the telemetry cleanup. | open |
| R-007 | technical | The invalid JSON handler changes the exit code to 1. A caller that treats setup exit 0 as success now sees a failure, and the atomic write must not run on that path. | low | medium | Check in both suites that the file is byte-identical and that no temporary file remains after the error. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A file count estimated at discovery is close enough to size a release. | A release runs over or under its budget, and the human corrects the fill at confirmation. | open |
