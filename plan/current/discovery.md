---
title: "Discovery - pending"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - pending

> Created at the start of discovery (P1), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` (assumed, only signal) |
| Detection signal | `plan/_archive/` holds 10 feature dirs, and `docs/about.md` exists |
| Git pre-flight | `feat/pending` cut from `main` at cc15394 after pull. PR #16 merged, so the redundant branch `chore/override-delete-redundant-branches` was deleted. No open PRs. Working tree clean. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.6.0`. `product.yml` and `planifest-zero/component.yml` agree. 0000039 shipped without a bump.
- Prior features (`plan/_archive/`):
  - 0000034 setup hardening (2026-10-16)
  - 0000035 PowerShell setup parity (2026-10-17)
  - 0000038 setup hook filter fixes (2026-10-19)
  - 0000039 setup hardening and release sizing (2026-10-19)
- Constraining ADRs (unless superseded):
  - 0000039 ADR-002: invalid JSON in `settings.json` prints one fixed line naming the file, leaves the file unchanged, and exits 1. The message never includes file content.
  - 0000039 ADR-003: a single-object `hooks` event value is treated as an array.
  - 0000039 ADR-004: `releaseSize` lives in `product.yml`.
  - 0000033 req-004: setup never logs `settings.json` contents.
- Component / data-ownership map (`docs/`): one component, `planifest-zero`. It owns the setup scripts, hooks, skills, templates, and tests.

## Release sizing

`releaseSize` is absent from `product.yml`, so the budget is 8 points (medium).

| Backlog entry | Files likely touched | Class | Points |
|---------------|----------------------|-------|--------|
| 0000120 `setup.ps1` calls some valid JSON invalid | `setup.ps1`, PowerShell tests | M | 2 |
| 0000121 `setup.sh` mishandles non-object JSON | `setup.sh`, shell tests | M | 2 |
| 0000122 `Test-JsonText` slows on deep nesting | `setup.ps1` | S | 1 |
| 0000101 park a part-finished feature | orchestrator skill, park template, `gate-write.mjs`, pipeline reference, tests | M | 2 |

Total: 7 of 8 points. The human chose this fill.

Entries left in the backlog: 0000095, 0000098, 0000099, 0000100, 0000110.

## Repo instructions

`planifest-overrides/instructions/` holds five files:

- `custom-001-local-git-only.md`
- `custom-002-prefer-subagent-decomposition.md`
- `custom-003-git-up-to-date-shorthand.md`
- `custom-004-p9-push-and-raise-pr.md`
- `custom-005-delete-redundant-local-branches.md`

## Hooks

`.claude/settings.json` registers `gate-write`. `plan/.orchestrator-strict` exists.
