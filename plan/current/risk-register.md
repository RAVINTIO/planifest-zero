---
title: "Risk Register - ravintio-rebrand"
summary: "Technical, operational, and compatibility risks for the RAVINTIO Zero rebrand."
status: "active"
version: "1.0.0"
---
# Risk Register - ravintio-rebrand

**Skill:** plan
**Feature:** 0000160-ravintio-rebrand
**Version:** 1.0.0
**Overall Risk Level:** high

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A mechanical replace corrupts a file. `setup.ps1` holds a mojibake sequence near line 1010 that a text replace can damage. | medium | high | Replace per token with byte-exact tools. Run every suite on Bash, Windows PowerShell 5.1, and PowerShell 7. | open |
| R-002 | operational | A consumer runs the new setup before the migration, which leaves old and new folders side by side. | medium | medium | Setup detects a `planifest-zero/` or `planifest-overrides/` folder and tells the consumer to run the migration first. | open |
| R-003 | operational | Old URLs break before the org rename lands. | high | low | The human renames the org soon after merge. | open |
| R-004 | technical | A consumer's installed `.github/workflows/planifest.yml` keeps calling `planifest-zero/` paths. Setup never overwrites it, so CI fails after the upgrade. | high | high | The migration replaces the workflow with `ravintio.yml` and removes the old file. A migration test uses a planifest-named consumer fixture. | open |
| R-005 | operational | The OTEL labels change from `planifest.roadmap` and `planifest.step` to `ravintio.roadmap` and `ravintio.step`. Dashboards and alerts that query the old labels return no data. | medium | medium | Document the label change in the migration and the changelog. Cover the new names in the labels test. | open |
| R-006 | compliance | A consumer's `PLANIFEST_ROADMAP_MODEL` or `PLANIFEST_ROADMAP_MAX_TURNS` is ignored after the rename, which changes the model or turn limit silently. | medium | medium | Read the old names as fallbacks in 1.x. Test that the new name wins and the old name still works. | open |
| R-007 | technical | The guard test blocks legitimate old names, such as the fallback variables, the old sentinel, and the migration files. The allowlist may also be too wide and hide real misses. | medium | medium | Keep the allowlist to named paths and tokens. Add a test that plants "Planifest" in a tracked file and expects failure. | open |
| R-008 | technical | `core.hooksPath` still points at `planifest-zero/hooks` in a self-hosted or consumer clone. Git skips the hooks once the folder moves. | medium | high | Setup re-sets `core.hooksPath` to `ravintio-zero/hooks` on every run. The migration does the same. | open |
| R-009 | operational | Old marker files such as `.planifest-session` and `.planifest-manifest` stay behind and confuse detection. | medium | low | Setup and the migration remove old markers. Tests check that none remain. | open |
| R-010 | operational | Renaming `planifest-*` skills leaves orphan skill folders in a consumer's installed tool directory. | low | medium | Setup already prunes skills the pack no longer ships. Add a test that the old skill names go on the next run. | open |
| R-011 | operational | Sibling repos and their docs still link to `planifest` org URLs after the pack changes. | medium | low | Sibling repos are out of scope. Log a follow-up edit for their links after the org rename. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Sibling repos keep their repo names after the org rename. | README links to them need a follow-up edit. | open |
| A-002 | GitHub Pages does not redirect `planifest.github.io`. | None, because the links move to the new domain anyway. | open |
