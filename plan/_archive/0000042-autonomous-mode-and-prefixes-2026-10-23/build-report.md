# Build Report - 0000042-autonomous-mode-and-prefixes

Source: the archived `build-log.md`. Phase headings use the run's own P1 to P5 numbers.

## Agents and model tiers

| Phase | Agents | Model tier | Parallel batches |
|-------|--------|------------|------------------|
| P1 Discovery | 0 | primary | 0 |
| P2 Plan | 12 | primary (requirements, ADRs), cheaper (scope, risk register, glossary) | 3 |
| P3 Implement | 5 | primary | 4 |
| P4 Validate and Accept | 2 | primary (security review), cheaper (checks) | 1 |
| P5 Ship | 0 | primary | 0 |
| Total | 19 | | |

The build log records tiers per phase, not per agent, so this report gives no per-tier agent counts.

## Parallelism

- P2 ran three batches, including the split of four requirements into ten.
- P3 ran four batches in the planned order: REQ-004 to REQ-006, then REQ-001 to REQ-003 with REQ-007, then REQ-008 to REQ-010, then the living docs.
- P4 ran the security review and the verification in one parallel batch.
- P4 ran both fix cycles inline, because each touched files the other reports cite.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P2 | The consistency check flagged 7 to 9 criteria per requirement against a limit of 3. P2 split four requirements into ten. | Yes. Discovery could size requirements against the limit before P2. |
| P4 | F-007 and F-009: the loop-runner skill and the workflow kept retired prefixes. The req-005 guard didn't check those files. | Yes. The guard's file list missed `planifest-loop-runner`. |
| P4 | F-002 to F-004: autonomous lacked stop records, evidence redaction, and a credential stop. REQ-011 added them. | Partly. The design had no threat review of the new mode before P3. |

## Suggestions

- **P1 Discovery:** check each candidate requirement against the three-criteria limit before the design is confirmed.
- **P2 Plan:** for a feature that removes human stops, add a threat-review step to the plan so security gaps surface before P4.
- **P3 Implement:** derive guard-test file lists from a grep, not a fixed list, so a new file can't escape the check.
