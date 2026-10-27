---
title: "Discovery - 0000204-run-and-initiative-retrospectives"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000204-run-and-initiative-retrospectives

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000204-run-and-initiative-retrospectives cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.25.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.26.0`.
- Prior features (`plan/_archive/`): latest is 0000203-blameless-postmortems (2026-10-27, step 8 of this initiative).
- Constraining ADRs (unless superseded): ADR-002 of the postmortem feature keeps records in `plan/postmortems/`, outside `plan/current/`. A retrospective record follows the same rule.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000178 (add retrospectives at the end of a run and an initiative).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Skill count today: 14, named in `component.yml`, `pipeline-reference.md`, `docs/architecture-overview.md`, and three tests (`0000031` req-003 and req-004, `0000160` req-001).
- Skill text budget: test `0000031` req-003 caps all `SKILL.md` text at 1520 lines.
- Postmortems: `ravintio-postmortem` writes to `plan/postmortems/`. The retrospective reads them.
- Ship: Step 5 writes `build-report.md`. A run retrospective follows it.
- I-E Delivery: roadmap standards archive the initiative, then raise the PR. The initiative retrospective goes between the two.
- Discovery step 11 and I-A Chart: neither reads past retrospectives today.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
