---
title: "Risk Register - powershell-setup-parity"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.4.2"
---
# Risk Register - powershell-setup-parity

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000035-powershell-setup-parity
**Version:** 0.4.2
**Overall Risk Level:** low

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Every `setup.ps1` change ships without a runtime test, because no `pwsh` exists locally or in CI. | medium | medium | Static suites, plus a manual Windows check in the PR test plan. | open |
| R-002 | operational | A re-run of the new `setup.ps1` on a project wired by the old one keeps the old `Write|Edit` `gate-write` entry and adds new ones, so `gate-write` runs twice. | medium | medium | The `PreToolUse` filter matches by command on any matcher. A suite asserts it. | open |
| R-003 | operational | Case-sensitive flags reject `--Strict-Orchestrator`, which 0.4.1 accepted. | low | low | Setup prints `Unknown flag` and exits 1. | open |
| R-004 | technical | Replacing `-AsHashtable` changes how `Merge-AllowedTools` serialises other keys in `settings.json`. | low | medium | The other three writers already use `PSCustomObject`, so output matches theirs. | open |
| R-005 | security | The leftover removal follows a planted symlink and deletes its target. | low | medium | `rm -f` and `Remove-Item` on a link remove the link only. A req-005 test plants a symlink. | open |
