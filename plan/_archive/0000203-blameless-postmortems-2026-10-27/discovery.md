---
title: "Discovery - 0000203-blameless-postmortems"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000203-blameless-postmortems

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000203-blameless-postmortems cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.24.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.25.0`.
- Prior features (`plan/_archive/`): latest is 0000202-improvement-loops (2026-10-27, step 7 of this initiative).
- Constraining ADRs (unless superseded): ADR-004 of the file-backlog feature keeps that skill off the target repo's git state. It does not bind a new skill.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000177 (add a blameless postmortem skill).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Skill count today: 13, named in `component.yml`, `pipeline-reference.md`, `docs/architecture-overview.md`, and `test-0000031-req-003-five-phases.sh`.
- Skill registry: `orchestrator-skills-catalogue.md` lists standalone skills and their triggers.
- Orchestrator stops: Exception Stops appends `Blocked:` and `Resolved:` lines to the build log. A postmortem trigger reads those lines.
- Archive step: ship moves `plan/current/` to `plan/_archive/`, so a record kept outside `plan/current/` survives.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
