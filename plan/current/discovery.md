---
title: "Discovery - 0000041-setup-cleanup-and-park-hardening"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000041-setup-cleanup-and-park-hardening

> Created at the start of discovery (P1), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ has feature dirs, docs/about.md exists` |
| Git pre-flight | `main clean and level with origin/main. Branch feat/0000041-setup-cleanup-and-park-hardening cut from main.` |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.7.0`
- Release budget: `releaseSize` absent from `product.yml`, so the `medium` budget of 8 points applies.
- Prior features (`plan/_archive/`): 0000030 to 0000040. The latest is 0000040-setup-json-checks-and-park (2026-10-22), which added the settings shape check and the park command.
- Constraining ADRs (unless superseded):
  - 0000033 ADR-002: the legacy telemetry cleanup runs on every setup run, warns and continues on failure.
  - 0000033 req-004: setup never prints `settings.json` content or a parser message.
  - 0000037 ADR-003: a present non-array `hooks.PreToolUse` or `hooks.UserPromptSubmit` gets a warning and a replacement.
  - 0000040 ADR-002: the shared shape check line for valid JSON that is not a settings object.
- Component / data-ownership map (`docs/`): one component, `planifest-zero`. Setup owns the hook wiring in `.claude/settings.json`. The orchestrator owns `plan/` working state.
- Repo instructions (`planifest-overrides/instructions/`): five files, custom-001 to custom-005. They cover git permissions, subagent decomposition, the GUTD shorthand, push and PR at ship, and deleting redundant local branches.
- Code locations for the pulled-in entries:
  - `remove_legacy_telemetry_wiring` in `planifest-zero/setup.sh` (0000127). It parses `settings.json` with no shape check.
  - `Remove-LegacyTelemetryWiring` in `planifest-zero/setup.ps1` (0000128). It has no shape check.
  - The non-array warning at `planifest-zero/setup.sh:495` and `planifest-zero/setup.ps1:464` (0000130). Both print the old value.
  - `park` in `.claude/skills/planifest-orchestrator/scripts/park.mjs` (0000129).
- Tooling: `pwsh` is not installed on this machine, so PowerShell tests run in CI only.
