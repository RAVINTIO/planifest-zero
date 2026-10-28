---
title: "Discovery - 0000252-chart-rules"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000252-chart-rules

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000252-chart-rules`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.39.1`.
- Prior features: 0000249, 0000250, 0000251, all archived 2026-10-28.
- Component map: one component, `ravintio-zero`.
- Backlog entries: 0000223, 0000225, and 0000234.
  - 0000223: chart has no check for an entry that widens what a fail-closed guard lets through.
  - 0000225: chart does not list the confirmations that a step's skills ask for.
  - 0000234: no chart row says whether a step may skip P1.
- Files in play: `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/templates/initiative.template.md`, `ravintio-zero/skills/ravintio-initiative/SKILL.md`, and `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-session-commands.md`.
- The driver reads only the `## Steps` table of `initiative.md`. A new section does not affect it.
- Size: pack skills hold 1,540 of 1,720 lines. The orchestrator `SKILL.md` holds 8,098 of 9,000 bytes.
- Constraint from the initiative: no step may widen `merge-guard`, `gate-write`, or another fail-closed hook. This feature adds chart rules only.
- The skills pack already holds override `custom-006`, the standing approval that entry 0000225 grew from.
- Version: the chart sets a minor bump, so 0.40.0.

## Past retrospectives

- 0000195: the source retrospective for all three entries.
