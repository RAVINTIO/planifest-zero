---
title: "Risk Register - setup-hook-filter-fixes"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.5.1"
---
# Risk Register - setup-hook-filter-fixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000038-setup-hook-filter-fixes
**Version:** 0.5.1
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Windows PowerShell 5.1 unwraps a one-item array when `setup.ps1` rebuilds `entry.hooks`. | medium | medium | Build the array with `@()` and test on 5.1 in CI. | open |
| R-002 | technical | Rerun idempotence breaks, so a Planifest entry appears twice. | low | medium | Add a run-twice case to both suites. | open |
| R-003 | operational | `pwsh` isn't installed locally, so only CI proves the `.ps1` suite. | medium | low | Open a draft PR early so CI runs during P3. | open |
| R-004 | technical | The two scripts each hold their own copy of the filter rule, so they can drift apart again. | low | medium | Run both suites on the same planted fixtures and compare the resulting entries. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | No user relies on setup removing their non-Planifest commands. | A stale user command stays, and the user removes it by hand. | open |
