---
title: "Discovery - 0000248-ship-merge-and-wall-clocks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000248-ship-merge-and-wall-clocks

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000248-ship-merge-and-wall-clocks`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.36.0`.
- Prior features: 0000245, 0000246, 0000247, all archived 2026-10-28.
- Constraining ADRs: none touch the ship skill or build log checks.
- Component map: one component, `ravintio-zero`.
- Backlog entries: 0000228, 0000232.
  - 0000228: `ravintio-ship/SKILL.md` names the merge carve-out but shows no merge command. I-D Advance step 4 in `roadmap-standards.md` holds the line with the placeholder `{n}` and no literal-number rule. Agents built the line with command substitution and `merge-guard` blocked it.
  - 0000232: ship Step 3 says to fill the P4 `End`, the P4 `Wall clock`, and the `Total wall clock`. Nothing checks the result. `consistency-check.mjs` checks the plan artifacts, has no build log check, and runs at P1 before the phase blocks exist.
- Tests that hold counts and caps: skill text 1,720 lines across all pack skills (`test-0000031-req-003-five-phases.sh`, 1,512 lines now) and orchestrator `SKILL.md` 9,000 bytes.
- Version: chart sets a minor bump, so 0.37.0.

## Past retrospectives

- 0000195: the source retrospective for both entries.
