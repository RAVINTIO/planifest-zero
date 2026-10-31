# Risk Register - plan concurrent work

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Version:** 0.23.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Check 8 flags a valid plan because the table format is strict | medium | low | The template shows the exact columns and the guide gives a worked example. The check message names the rule. | open |
| R-002 | operational | The plan lists batches and the implement phase dispatches in sequence anyway | medium | medium | The dispatch standard and the implement skill name the plan as the source and require a build log entry for a departure. | open |
| R-003 | technical | The write-target comparison misses overlap between a directory and a file in it | low | low | Units list files, and the guide says so. A later release can add path prefix matching. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The plan skill is the only writer of `execution-plan.md` | A plan written elsewhere skips the section and the check fails it | open |
| A-002 | Existing consistency tests build fixtures without `execution-plan.md` | Check 8 breaks them | open |
