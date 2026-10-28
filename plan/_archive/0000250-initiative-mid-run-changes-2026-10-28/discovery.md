---
title: "Discovery - 0000250-initiative-mid-run-changes"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000250-initiative-mid-run-changes

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000250-initiative-mid-run-changes`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.38.0`.
- Prior features: 0000247, 0000248, 0000249, all archived 2026-10-28.
- Component map: one component, `ravintio-zero`.
- Backlog entries: 0000226 and 0000227.
  - 0000226: the human asked for a standing approval mid-run in initiative 0000195. The initiative session tried to write the override and `gate-write` blocked it. The human moved it into step scope. The initiative skill has no rule for this.
  - 0000227: initiative 0000195 step 10 changed the driver, the watcher, and the initiative skill. The old driver kept running later steps with its launch code.
- Files in play: `ravintio-zero/skills/ravintio-initiative/SKILL.md` (87 lines), `ravintio-zero/scripts/initiative-run.mjs` (444 lines), `ravintio-zero/standards/roadmap-standards.md`.
- Tests that hold counts and caps: skill text 1,720 lines across all pack skills (1,530 lines now).
- Constraint from the initiative: no step may widen `merge-guard`, `gate-write`, or another fail-closed hook.
- The initiative skill forbids editing the working tree while the driver lock is held. The routing rule for 0000226 must respect that.
- The running driver loaded its code at activation. Step 12 changes `initiative-run.mjs`, so the running driver keeps the old behaviour until the human restarts it.
- Version: the chart sets a minor bump, so 0.39.0.

## Past retrospectives

- 0000195: the source retrospective for both entries.
