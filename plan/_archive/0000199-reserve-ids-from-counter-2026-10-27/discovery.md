---
title: "Discovery - 0000199-reserve-ids-from-counter"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000199-reserve-ids-from-counter

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000199-reserve-ids-from-counter cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.20.2`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.21.0`.
- Prior features (`plan/_archive/`): latest is 0000198-cap-echoed-plan-text (2026-10-27, step 3 of this initiative).
- Constraining ADRs (unless superseded): none touch id allocation.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entry pulled in: 0000183 (reserve ids from a counter file).
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Files that state the "highest ever allocated plus one" rule: `ravintio-zero/skills/ravintio-file-backlog/SKILL.md`, `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` (backlog pickup), `ravintio-zero/templates/backlog-entry.template.md`, `ravintio-zero/templates/initiative.template.md`, `ravintio-zero/standards/roadmap-standards.md`, and `ravintio-zero/standards/agent-dispatch-standards.md`.
- Tests that assert the old wording: `test-0000025-req-005-backlog-unification.sh`, `test-0000164-req-005-file-backlog-skill.sh`. `test-0000043-req-001-roadmap-drafts.sh` asserts the folder names in roadmap-standards.
- Counter seed: backlog entry 0000209 is the highest id in use and feature ids 0000196 to 0000208 are reserved by the initiative. The counter seeds at `0000210`.
- Installed copies under `.claude/` are git-ignored and refresh at step 13.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
