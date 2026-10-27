---
title: "Discovery - 0000197-merge-guard-block-message"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000197-merge-guard-block-message

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000197-merge-guard-block-message cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.20.0`. `product.yml` agrees. Step bump is `patch`, so the new version is `0.20.1`.
- Prior features (`plan/_archive/`): latest is 0000196-setup-argument-checks (2026-10-27, step 1 of this initiative).
- Constraining ADRs (unless superseded): 0000043 ADR-003 set the fail-closed rule for `merge-guard`. Backlog entry 0000190 keeps it and changes only the message.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000190 (merge-guard gives the wrong reason).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Files in scope: `ravintio-zero/hooks/enforcement/merge-guard.mjs`, `ravintio-zero/tests/test-0000043-req-006-merge-guard-hook.sh`, and docs that describe the block message.
