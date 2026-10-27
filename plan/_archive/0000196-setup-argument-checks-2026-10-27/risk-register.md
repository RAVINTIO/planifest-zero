---
title: "Risk Register - setup argument checks"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - setup argument checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Version:** 0.20.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A consumer refresh command or CI job that still passes a retired flag now fails with exit 1 | medium | low | The error names the flag and says to remove it. The refresh skill omits the flag from its proposed command. | open |
| R-002 | technical | `setup.sh` and `setup.ps1` drift in error text or exit code | low | medium | Each requirement has an acceptance criterion in both shells, and the tests assert the same text. | open |
| R-003 | technical | The PowerShell suite cannot run locally when `pwsh` is absent | medium | medium | CI runs the PowerShell suites. The build report states whether `pwsh` ran locally. | open |
| R-004 | technical | Moving the tool check changes the order of output for an old-folder failure | low | low | An unknown tool now reports before the old-folder message. The existing old-folder tests use a valid tool. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Backlog line numbers are approximate | P2 locates each block by name instead | open |
| A-002 | A tool name that starts with `--` fails parsing as an unknown flag | The tool check still rejects it | open |
