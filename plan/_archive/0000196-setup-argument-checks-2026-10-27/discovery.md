---
title: "Discovery - 0000196-setup-argument-checks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000196-setup-argument-checks

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000196-setup-argument-checks cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.19.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.20.0`.
- Prior features (`plan/_archive/`): latest are 0000185-explain-strict-mode (2026-10-25), 0000189-name-the-roadmap-initiative and 0000192-rename-runner-lock-and-archive (both 2026-10-26).
- Constraining ADRs (unless superseded): 0000034 ADR-001 chose a warning for retired flags. Backlog entry 0000194 reverses it, so this run supersedes that decision. 0000160 ADR-003 set the old-folder check and its migration message.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entries pulled in: 0000193 (validate tool first), 0000194 (fail on retired flags).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Files in scope: `ravintio-zero/setup.sh`, `ravintio-zero/setup.ps1`, six existing retired-flag tests, two new tests, and the `ravintio-refresh-setup` skill check.
