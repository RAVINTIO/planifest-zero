---
title: "Scope - self-host-on-planifest-zero"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.5.0"
---
# Scope - self-host-on-planifest-zero

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Wave:** not waved
**Version:** 0.5.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Remove the `validate-telemetry-schema` CI job and the comment that names the old folder (req-001).
- Remove `--structured-telemetry-mcp` from `refresh-planifest-zero-dir.ps1` (req-002).
- Write `plan/state/claude-code.md` with an empty `flags` array and no `backendUrl`. Remove `planifest-overrides/setup-config/` (req-003).
- Update `planifest-zero/tests/README.md`. Point `core.hooksPath` at `planifest-zero/hooks`, then run `git rm -r planifest-framework/` (req-004).
- Reword `custom-004-p9-push-and-raise-pr.md` to name the ship phase in place of P9 (req-005).
- Add a `bash-suites` CI job on `ubuntu-latest` with `PLANIFEST_REQUIRE_PWSH=1`, a pinned checkout, and `contents: read` (req-006, backlog 0000108).
- Make the `setup.sh` `PreToolUse` filter match Planifest entries by module name on any matcher (req-007, backlog 0000106).
- In `setup.sh` and `setup.ps1`, warn and replace a non-array `PreToolUse` or `UserPromptSubmit` value (req-008, backlog 0000107).
- In the `planifest-zero` orchestrator, assume standard-iterative mode when it's the only signal (req-009, backlog 0000103).
- A suite for each of the nine requirements.
- The living docs and version records for 0.5.0.

## Out of Scope

- Retiring the legacy telemetry cleanup (backlog 0000095). This repo's own reinstall still needs it.
- Release sizing and the pipeline-governance group (backlog 0000098 to 0000101 and 0000109).
- Changes to the five-phase pipeline in `planifest-zero/`.
- Rewriting historical records under `plan/` or `docs/decisions-index.md`.

## Deferred

- The local reinstall of `.claude/` and `CLAUDE.md` with `planifest-zero/setup.sh claude-code`. The human runs it after merging, because setup prunes the old skills that this run uses.
  - Blocks: the next feature runs on the five-phase pipeline only after this reinstall. Until then, sessions load the old installed skills.
