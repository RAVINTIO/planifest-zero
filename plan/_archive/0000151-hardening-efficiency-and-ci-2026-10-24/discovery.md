---
title: "Discovery - 0000151-hardening-efficiency-and-ci"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000151-hardening-efficiency-and-ci

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories (latest `0000043-autonomous-roadmaps-2026-10-24`) |
| Git pre-flight | PR #21 merged. `main` synced to `8b1e929`. Redundant branch `feat/0000043-autonomous-roadmaps` deleted. Branch `feat/0000151-hardening-efficiency-and-ci` cut from `chore/backlog-0000150-faster-powershell-ci` (PR #22, open), which adds one backlog entry to `main`. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`, `planifest-zero/component.yml`): `0.10.0`. Latest tag `v0.10.0`.
- Prior features (`plan/_archive/`): 0000030 to 0000043. The latest, 0000043, added roadmaps, the `roadmap-run.mjs` driver, and the `merge-guard` hook.
- Constraining ADRs (unless superseded):
  - 0000043 ADR-004: the driver runs each roadmap step in a fresh `claude -p` session.
  - 0000043 ADR-006: roadmap steps self-confirm their gates.
  - 0000042 ADR-002: gated and autonomous run modes, with five exception stops.
  - 0000041 ADR-002: setup never shows a raw node error for an unreadable `settings.json`.
  - 0000040 ADR-005: park keeps the work on the feature branch.
- Component / data-ownership map (`docs/`): one component, `planifest-zero`, a component pack of skills, hooks, scripts, templates, and standards.
- Repo instructions (`planifest-overrides/instructions/`): five files.
  - `custom-001-local-git-only.md`: merging into `main` is human-only.
  - `custom-002-prefer-subagent-decomposition.md`
  - `custom-003-git-up-to-date-shorthand.md`
  - `custom-004-ship-push-and-raise-pr.md`: push the branch and the tag, then raise the PR.
  - `custom-005-delete-redundant-local-branches.md`
- Strict mode: `plan/.orchestrator-strict` is present. The run wrote `plan/.orchestrator-ack`.
- Pending migrations: none.

## Backlog

| Entry | Status | Relevance |
|-------|--------|-----------|
| 0000095-retire-legacy-telemetry-cleanup | open | left in backlog |
| 0000100-workflow-quality-and-governance-gates | open | left in backlog |
| 0000110-subagent-acceleration | open | left in backlog |
| 0000139-setup-sh-read-only-settings-stack-trace | open | pulled in |
| 0000142-park-entry-path-follows-symlinks | open | pulled in (security) |
| 0000143-stale-installed-hooks | open | pulled in |
| 0000144-ship-sentinel-commit-after-pr | open | pulled in |
| 0000145-roadmap-driver-step-log | open | pulled in |
| 0000146-hook-block-messages-on-stderr | open | pulled in |
| 0000147-chart-front-load-step-stops | open | pulled in |
| 0000148-token-efficiency-recommendations | open | pulled in. It holds six numbered changes. |
| 0000149-label-headless-roadmap-steps-in-telemetry | open | pulled in |
| 0000150-faster-powershell-ci | open | pulled in. It reaches `main` through PR #22. |

Backlog id high-water mark: `0000150`. This feature takes `0000151`.

## Release sizing

- `releaseSize` in `product.yml`: absent, so the `medium` budget of 8 points applies.
- Candidate estimate: 19 points.

| Entry | Class | Points |
|-------|-------|--------|
| 0000139 | S | 1 |
| 0000142 | S | 1 |
| 0000143 | S | 1 |
| 0000144 | S | 1 |
| 0000145 | M | 2 |
| 0000146 | M | 2 |
| 0000147 | M | 2 |
| 0000148 | L | 4 |
| 0000149 | S | 1 |
| 0000150 | M | 2 |
| Unestimated overhead (`setup.ps1` parity, test updates) | M | 2 |

- The human chose one oversized release over a two-step roadmap.
