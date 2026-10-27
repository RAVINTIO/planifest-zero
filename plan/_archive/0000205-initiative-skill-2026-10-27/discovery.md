---
title: "Discovery - 0000205-initiative-skill"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000205-initiative-skill

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000205-initiative-skill cut from initiative/0000195-backlog-clearance. Untracked: plan/backlog/0000210-plan-checks-count-and-cap-tests/ (queued by an earlier step, left alone for step 13).` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.26.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.27.0`.
- Prior features (`plan/_archive/`): latest is 0000204-run-and-initiative-retrospectives (2026-10-27, step 9 of this initiative).
- Constraining ADRs (unless superseded): ADR-002 of the postmortem feature and ADR-002 of the retrospective feature keep records outside `plan/current/`. The initiative skill writes nothing to `plan/current/`.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000182 (an initiative skill coordinates initiative delivery).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Driver: `ravintio-zero/scripts/initiative-run.mjs` reads only `plan/current/build-log.md` for a `Blocked:` line. It reads `position` from the working tree. It passes `process.env` to the child unchanged.
- Hooks: `auto-trigger-orchestrator.mjs` loads the orchestrator when `plan/.orchestrator-active` is absent. `check-orchestrator-presence.mjs` compares `plan/.orchestrator-ack` to the session id in strict mode.
- Orchestrator Resume Detection step 3 resumes an active initiative. Discovery Start Actions and I-A to I-E live in `ravintio-zero/standards/roadmap-standards.md` and the orchestrator.
- Skill count today: 15 in `ravintio-zero/skills/`. Tests that pin skill counts or the skill text budget change with a new skill.
- Backlog counter: `plan/backlog/.next-id` holds `0000211`.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
