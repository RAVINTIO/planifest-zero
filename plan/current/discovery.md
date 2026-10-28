---
title: "Discovery - 0000249-check-path-before-missing-claims"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000249-check-path-before-missing-claims

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000249-check-path-before-missing-claims`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.37.0`.
- Prior features: 0000246, 0000247, 0000248, all archived 2026-10-28.
- Constraining ADRs: none touch the validate-and-accept skill.
- Component map: one component, `ravintio-zero`.
- Backlog entry: 0000233.
  - Step 12 of initiative 0000195 reported "No Codex program was available" while `/opt/homebrew/bin/codex` existed. The acceptance evidence repeated the claim.
  - The same step marked all 12 criteria `verified`, though one claim rested on the Codex docs alone. Step 14 ran the real program and found the claim false.
  - `ravintio-validate-and-accept/SKILL.md` has no rule that searches the `PATH` before a report says a program is missing. It also has no status for a claim that only documentation backs.
- Tests that hold counts and caps: skill text 1,720 lines across all pack skills (`test-0000031-req-003-five-phases.sh`, 1,526 lines now).
- Version: chart sets a minor bump, so 0.38.0.

## Past retrospectives

- 0000195: the source retrospective for entry 0000233.
