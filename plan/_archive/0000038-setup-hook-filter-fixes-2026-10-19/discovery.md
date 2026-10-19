---
title: "Discovery - 0000038-setup-hook-filter-fixes"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000038-setup-hook-filter-fixes

> Created at the start of discovery (P1), before the first coaching question.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature folders, and `docs/about.md` exists |
| Git pre-flight | PR #12 merged. `main` matches `origin/main` at `968f525`. Branch `feat/0000038-setup-hook-filter-fixes` created from `main`. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md` and `product.yml`): `0.5.0`
- Prior features (`plan/_archive/`): 0000030 to 0000037. The latest is 0000037-self-host-on-planifest-zero (2026-10-17), which moved this repo onto `planifest-zero/`.
- Constraining decisions (unless superseded):
  - 0000034 ADR-002: settings writes are atomic.
  - 0000035 ADR-001: `setup.ps1` wires the same hooks as `setup.sh`.
  - 0000035 S-004: a command is Planifest only when it runs `<module>.mjs` at a path boundary, matched case-sensitively.
  - 0000037 ADR-003: the `PreToolUse` filter applies on any matcher, and a non-array event value gets a warning.
- Component map (`docs/`): one component, `planifest-zero`. It owns no data store. The setup scripts write the consumer's `settings.json`.
- Repo instructions (`planifest-overrides/instructions/`): custom-001 to custom-004. Push and `gh pr create` are pre-authorised. The human merges.
- Product id: `planifest-zero` in `product.yml`.
- Migrations: none pending in `planifest-zero/migrations/`.
- Backlog: nine open entries. 0000111 and 0000112 are the confirmed pull-ins.
- Backlog id high-water mark: `0000112`.

## Code findings

- `planifest-zero/setup.sh` line 497: the `UserPromptSubmit` filter matches by bare substring, such as `includes("check-design")`.
- `planifest-zero/setup.ps1` line 343: the same filter uses the path-boundary regex. The two scripts disagree (0000111).
- Both scripts drop a whole hook entry when any one of its commands is a Planifest module. That holds for `PreToolUse` and `UserPromptSubmit` (0000112).
- The telemetry cleanup in `setup.sh` already filters one command at a time. It keeps an entry with its other commands. That is a precedent for 0000112.
- The installed `.claude/settings.json` still holds old telemetry entries. The pending reinstall removes them.
