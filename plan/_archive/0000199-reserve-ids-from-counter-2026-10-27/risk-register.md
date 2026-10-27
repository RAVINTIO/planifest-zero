# Risk Register - reserve ids from a counter

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Version:** 0.21.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A stopped process leaves a stale lock and blocks reservation | low | low | The script exits 1 and names the lock path. The human removes it. It never removes a lock itself. | open |
| R-002 | operational | Two branches reserve the same ids | medium | low | Git shows a conflict on `.next-id`. The docs state the answer: keep the higher value and renumber the later branch. | open |
| R-003 | technical | A doc keeps the folder-scan rule | low | medium | A test searches the six docs for the old wording. | open |
| R-004 | technical | A write failure truncates the counter | low | medium | The script writes a temporary file and renames it over the counter. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A conflict on `.next-id` resolves by keeping the higher value | Two entries share an id until someone renumbers one | open |
