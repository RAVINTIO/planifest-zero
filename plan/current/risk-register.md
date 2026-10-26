---
title: "Risk Register - name-the-roadmap-initiative"
summary: "Four risks and four logged assumptions for the roadmap initiative rename, with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - name-the-roadmap-initiative

**Skill:** plan
**Feature:** 0000189-name-the-roadmap-initiative
**Version:** 0.19.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A missed old name breaks the driver or `merge-guard` at the next activation. | medium | high | The old-name search test runs in CI. Dry run the driver against a stub initiative. | open |
| R-002 | operational | `.claude/skills/` drifts from `ravintio-zero/skills/`. | high | medium | Run setup after P2, which the human pre-approved at P0. Then check that the copies match. | open |
| R-003 | technical | A rename breaks a Windows-only test path. | low | medium | Run the PowerShell suites locally with `pwsh`. Treat Windows PowerShell 5.1 as CI-only. | open |
| R-004 | technical | The old-name search test allowlist grows too broad and hides a real miss. | low | medium | The allowlist names exact paths, not folders. The only folder entries are `plan/_archive/`, `plan/changelog/`, and `plan/current/`, which ship archives. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | This repo is the only consumer of the pack today. | Another consumer must run migration `0005`, which the design already provides. | open |
| A-002 | No initiative is active while this feature runs. | A running driver breaks on the new names. | open |
| A-003 | US-001 says "four initiative states", but the design lists five: proposed, charted, active, delivered, and blocked. The plan treats it as five. | The glossary or the status field misses a state. | open |
| A-004 | Removing the `PLANIFEST_ROADMAP_*` fallback breaks no one, because migration 0004 already retired Planifest names. | A consumer that still sets one sees the driver stop, with the new name in the message. | open |
