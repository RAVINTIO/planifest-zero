# Risk Register - blameless postmortems

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Version:** 0.25.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A 5 whys chain blames a person or an agent | medium | medium | The skill rejects a chain that ends at a person or agent and asks why again. | open |
| R-002 | operational | Each stop adds a postmortem to the run | high | low | One record per stop, written once. The skill stays under 120 lines. | open |
| R-003 | security | A record copies a credential from a log | low | high | The skill forbids secrets in a record, and the pack's credential stop covers committed files. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The orchestrator can read `Blocked:` and `Resolved:` lines from the build log | The trigger never fires and the human requests a postmortem by hand | open |
