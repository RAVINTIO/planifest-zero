---
title: "Discovery - 0000202-improvement-loops"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000202-improvement-loops

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000202-improvement-loops cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.23.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.24.0`.
- Prior features (`plan/_archive/`): latest is 0000201-plan-concurrent-work (2026-10-27, step 6 of this initiative).
- Constraining ADRs (unless superseded): none touch the TDD inner loop or the refactor skill.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000179 (improve solutions in build and validate loops).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- TDD loop today: `ravintio-implement` dispatches test-writer, implementer, and refactor per requirement. Refactor runs once after GREEN and its report line is `REFACTOR ✓`. No step asks whether a cleaner design meets the same tests.
- Marker lines today: `ravintio-zero/standards/workflow-governance-standards.md` lists four markers. `workflow-metrics.mjs` counts them against thresholds. A new marker that the script does not count needs no script change.
- Fast batch today: one TDD track per requirement runs test-writer, implementer, and refactor in sequence.
- Scope decision: the wanted outcome names one improvement loop per requirement after GREEN. The loop lives in P2. Validate keeps its failure loops.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
