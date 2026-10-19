---
title: "Discovery - 0000039-setup-hardening-release-sizing"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000039-setup-hardening-release-sizing

> Created at the start of discovery (P1), before the first coaching question.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature folders, and `docs/about.md` exists |
| Git pre-flight | PR #13 merged. `main` matches `origin/main` at `328adfb`. Branch `feat/0000039-setup-hardening-release-sizing` created from `main`. |
| Skills inbox | empty (`.gitkeep` only) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md` and `product.yml`): `0.5.1`
- Prior features (`plan/_archive/`): 0000030 to 0000038. The latest is 0000038-setup-hook-filter-fixes (2026-10-19), which made setup filter hook commands one at a time.
- Constraining decisions (unless superseded):
  - 0000033 req-004: setup never logs the contents of `settings.json`.
  - 0000034 ADR-002: settings writes are atomic.
  - 0000035 ADR-001: `setup.ps1` wires the same hooks as `setup.sh`.
  - 0000037 ADR-003: a non-array hook event value gets a warning and a replacement.
  - 0000038 ADR-002: setup filters hook entries one command at a time. A non-array `hooks` value stays as it was.
- Component map (`docs/`): one component, `planifest-zero`. It owns no data store. The setup scripts write the consumer's `settings.json`.
- Repo instructions (`planifest-overrides/instructions/`): custom-001 to custom-004. Push and `gh pr create` are pre-authorised. The human merges.
- Product id: `planifest-zero` in `product.yml`.
- Migrations: none pending in `planifest-zero/migrations/`.
- Backlog: ten open entries. 0000109, 0000113, 0000114, and 0000115 are the confirmed pull-ins.
- Backlog id high-water mark: `0000115`.

## Code findings

- `planifest-zero/setup.sh` lines 465 and 542: `JSON.parse` runs with no handler. Invalid JSON prints the failing line and a stack trace (0000113).
- `planifest-zero/setup.sh` line 333: the telemetry cleanup also calls `JSON.parse`. The backlog entry says this step already handles the error, so P2 checks how.
- `planifest-zero/setup.ps1` lines 330 and 465: `ConvertFrom-Json` throws under `$ErrorActionPreference = 'Stop'`. The error text can include the bad token.
- `planifest-zero/setup.sh` line 490 and `setup.ps1` line 291: a non-array `hooks` value keeps the entry unchanged (0000114).
- `planifest-zero/setup.ps1` lines 346, 371, 384, 417, and 496: settings writes use `ConvertTo-Json -Depth 10` (0000115). Lines 1041 and 1083 write other files at the same depth.
- The fixed sizing rule "more than 3 user stories is too big" appears in three places (0000109):
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md` line 175
  - `planifest-zero/templates/feature-brief.template.md` line 25
  - `planifest-zero/templates/feature-brief-guide.md` line 43
- `product.yml` holds `id`, `name`, `version`, `feature`, `versionPolicy`, and `components`. No sizing field exists.
