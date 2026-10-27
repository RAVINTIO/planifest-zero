---
title: "Discovery - 0000198-cap-echoed-plan-text"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000198-cap-echoed-plan-text

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000198-cap-echoed-plan-text cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.20.1`. `product.yml` agrees. Step bump is `patch`, so the new version is `0.20.2`.
- Prior features (`plan/_archive/`): latest is 0000197-merge-guard-block-message (2026-10-27, step 2 of this initiative).
- Constraining ADRs (unless superseded): 0000170 ADR-004 added the Gherkin step guard to `ratchet-check.mjs`. 0000017 ADR-001 set the ratchet approval path. Neither changes.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000176 (cap plan text that the ratchet and consistency check print).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Files in scope: `ravintio-zero/hooks/enforcement/ratchet-check.mjs`, `ravintio-zero/scripts/consistency-check.mjs`, one new test suite, and docs that describe the printed text.
- Echo sites found: `ratchet-check.mjs` prints `removed: "${l}"` for each removed line. `consistency-check.mjs` prints the story map row `label` at two `findings.push` calls. No other finding echoes file text.
- Installed copy: `.claude/hooks/enforcement/ratchet-check.mjs` is identical to the pack source today. Setup refreshes it.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
