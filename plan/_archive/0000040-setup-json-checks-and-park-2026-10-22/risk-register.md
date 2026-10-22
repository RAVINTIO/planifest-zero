---
title: "Risk Register - setup-json-checks-and-park"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.7.0"
---
# Risk Register - setup-json-checks-and-park

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000040-setup-json-checks-and-park
**Version:** 0.7.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The fixed error lines in `setup.sh` and `setup.ps1` drift apart (req-001, req-002). The two scripts each hold their own copy of the shape check. | low | medium | Parity tests assert the exact line in both suites. | open |
| R-002 | operational | The session ends part way through park (req-004). The branch is pushed but no chore PR exists, so the backlog entry never reaches `main`. | low | medium | Resume detection finds `park.md` with no chore PR and finishes step 2 (req-005). | open |
| R-003 | operational | `pwsh` is missing on the review machine, so the PowerShell suite skips locally (req-002, req-003). Only CI proves it. | high | medium | CI runs the PowerShell suite. Open a draft PR early so CI runs during implement. | open |
| R-004 | security | A new error path prints `settings.json` content or a parser message. The depth cap and shape check add paths where `ConvertFrom-Json` can throw (req-001, req-002, req-003). | low | high | Print only the fixed line. Tests assert the exact stderr line and check that a planted value never appears (0000033 req-004). | open |
| R-005 | technical | The depth cap or the `Stack[char]` rewrite changes which inputs `Test-JsonText` accepts (req-003). Valid JSON nested up to 1024 levels could fail. | low | medium | Keep the existing `Test-JsonText` cases passing. Add cases at depth 1024 and 1025, and the 100,000-level timing case. | open |
| R-006 | security | Park or the chore branch step commits or pushes to `main` by mistake, because step 2 cuts the chore branch from `main` (req-004). | low | high | The skill text names the chore branch before any commit. Contract tests check that park never commits to `main`, never merges, and never force-pushes. | open |
| R-007 | operational | Discard deletes the wrong branch or deletes unpushed work on `origin` (req-005). | low | high | Discard deletes only after the human confirms. The prompt names the branch. The entry names the exact branch. | open |
| R-008 | technical | Resume merges `origin/main` into the parked branch and the merge conflicts (req-005). The branch may be old. | medium | medium | Resume stops on a conflict and reports it to the human. It never resolves the conflict alone. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `gh` is installed and authenticated when park runs. | Park stops at step 2 with the branch pushed, and the human files the PR. | open |
| A-002 | PowerShell 7 and 5.1 both throw on case-duplicate keys in `ConvertFrom-Json`. | The 0000120 test needs a version guard. | open |
