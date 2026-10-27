---
title: "Discovery - 0000201-plan-concurrent-work"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000201-plan-concurrent-work

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000201-plan-concurrent-work cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.22.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.23.0`.
- Prior features (`plan/_archive/`): latest is 0000200-reply-conventions (2026-10-27, step 5 of this initiative).
- Constraining ADRs (unless superseded): none touch the execution plan or the consistency check rules for it.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000180 (plan concurrent subagent work by default).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- What 0000172 already covers: `agent-dispatch-standards.md` holds a "Default posture: parallel" rule and `plan/.run-speed` fast batches per phase. Each phase skill lists its fast batch. None of that appears in the plan: the execution plan template has no section that lists units, dependencies, and batches, so the orchestrator decides batch by batch.
- Execution plan today: `ravintio-zero/templates/execution-plan.template.md` and its guide. The plan skill writes `plan/current/execution-plan.md`.
- Consistency check today: `ravintio-zero/scripts/consistency-check.mjs` runs checks 1 to 7 over `plan/current/`. It does not read `execution-plan.md`. Tests live beside it, for example `test-0000170-req-004-story-map-consistency-rule.sh`.
- Re-plan trigger: `references/orchestrator-mid-pipeline-changes.md` re-runs P1 for an additive or contradictory change. That re-run rewrites the plan, so the plan skill rule covers it.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
