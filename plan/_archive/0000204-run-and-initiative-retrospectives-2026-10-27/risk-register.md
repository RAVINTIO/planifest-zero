# Risk Register - run and initiative retrospectives

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Version:** 0.26.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | An observation blames a person or an agent | medium | medium | The skill rejects it and restates the gap in a process, check, standard, or tool. | open |
| R-002 | operational | Each run and each initiative adds a retrospective | high | low | One record per run and one per initiative. The skill stays under 120 lines. | open |
| R-003 | security | A record copies a credential from a log | low | high | The skill forbids secrets in a record, and the pack's credential stop covers committed files. | open |
| R-004 | operational | The driver that runs this initiative started before this step, so its I-E Delivery keeps the old rules | high | low | Step 13 reruns setup. The human runs the initiative retrospective by hand if delivery skips it. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The ship step can read the archived build log, the postmortems, and the `Rework:` lines | The retrospective omits evidence and the human requests a rerun | open |
| A-002 | I-E Delivery can read `initiative.md` and every step tag | The charted-versus-shipped comparison has gaps and the record says so | open |
