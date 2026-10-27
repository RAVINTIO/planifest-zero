---
title: "Discovery - 0000200-reply-conventions"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000200-reply-conventions

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories, and `docs/about.md` exists. No `external-versioning.md`. |
| Git pre-flight | `initiative step: branch feat/0000200-reply-conventions cut from initiative/0000195-backlog-clearance, working tree clean` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.21.0`. `product.yml` agrees. Step bump is `minor`, so the new version is `0.22.0`.
- Prior features (`plan/_archive/`): latest is 0000199-reserve-ids-from-counter (2026-10-27, step 4 of this initiative).
- Constraining ADRs (unless superseded): none touch reply prefixes or the Stop hook.
- Component / data-ownership map: one component, `ravintio-zero`. It owns all files. No datastore.

## Run inputs

- Backlog entries pulled in: 0000181 (phase prefixes appear inconsistently) and 0000209 (stop reporting routine compliance in replies). Both add a reply rule to the boot file and the orchestrator skill.
- Repo instructions: five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`).
- Approved dependencies from `initiative.md`: none. Schema changes: none.
- Prefix table today: only `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` defines the phase prefixes and the five initiative prefixes. The boot template `ravintio-zero/templates/standard-boot.md` and the plan, implement, validate-and-accept, and ship skills do not restate them.
- Stop hook today: `.claude/settings.json` holds `"Stop": []`. Setup wires six hooks from `setup.sh` and `setup.ps1`: gate-write, ratchet-check, em-dash-guard, merge-guard, auto-trigger-orchestrator, check-orchestrator-presence, and check-design. A parity suite (`test-0000035-req-001-hook-parity.sh`) compares the two scripts.
- Hook source lives in `ravintio-zero/hooks/enforcement/`. Installed copies under `.claude/` are git-ignored and refresh at step 13.
- Tool note: merge-guard blocks a Bash command with a long heredoc. Write files with the Write tool.
