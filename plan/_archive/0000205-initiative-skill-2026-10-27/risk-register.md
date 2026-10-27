# Risk Register - initiative skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Version:** 0.27.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Reading `position` from the branch ref breaks the older driver tests that edit the working tree | medium | medium | The driver falls back to the working tree outside a git repo. Tests that need the ref use a temporary repo. | open |
| R-002 | operational | Moving stage text out of the orchestrator leaves a stage with no owner | medium | medium | A test checks that each stage names exactly one owner. | open |
| R-003 | operational | The driver that runs this initiative started before this step and keeps the old checks | high | low | Step 13 reruns setup, and the next initiative uses the new driver. | open |
| R-004 | security | The watch script prints a credential from a build log line | low | high | The script cuts lines to 500 characters and prints build log lines only. The credential stop covers committed files. | open |
| R-005 | operational | The hooks load the wrong skill for a session | low | medium | Tests cover each branch, and a wrong load costs one prompt because both skills share the hard limits. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A step merges its feature PR into the initiative branch before the driver reads `position` | The driver stops with a not-merged line and the human restarts it | open |
| A-002 | The host offers a background monitor tool | The skill reports on each prompt and at phase ends only | open |
