---
title: "Discovery - 0000037-self-host-on-planifest-zero"
summary: "Raw P0 discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000037-self-host-on-planifest-zero

> Created at the start of P0, before the first coaching question, in every adoption mode.
> Raw findings only; decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so; coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature folders, and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000037-self-host-on-planifest-zero`, cut from `feat/0000036-test-runner-coverage`. PR #9 and PR #10 are open, so `main` lacks 0000035 and 0000036. |
| Skills inbox | `planifest-framework/skills-inbox/` is empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.4.3`
- Prior features (`plan/_archive/`):
  - 0000033-remove-telemetry-mcp, 2026-10-16: removed the telemetry MCP from the product.
  - 0000034-setup-hardening, 2026-10-16: retired flags warn, and settings writes are atomic.
  - 0000035-powershell-setup-parity, 2026-10-17: `setup.ps1` matches `setup.sh`.
  - 0000036-test-runner-coverage, 2026-10-17: the runner runs every suite, with a Windows CI job.
- Constraining ADRs:
  - 0000031 ADR-002: the product folder is `planifest-zero/`, and the old name has no live references.
  - 0000032 ADR-001: the setup record lives at `plan/state/{tool}.md`.
  - 0000033 ADR-001: telemetry isn't a framework concern.
  - 0000036 ADR-003: CI runs the PowerShell suites. The Bash suites wait for 0000097.
- Component and data-ownership map: one component, `planifest-zero`, which owns no data.

### Dependencies on `planifest-framework/`

- `planifest-framework/` holds 1,094 tracked files. It's the older 10-phase framework (P0 to P9).
- `planifest-zero/` runs a five-phase pipeline: discovery, plan, implement, validate-and-accept, and ship.
- The installed `.claude/` tree and `CLAUDE.md` are gitignored. Setup from `planifest-framework/` wrote them on 2026-08-30.
- That install still has telemetry wiring:
  - `.claude/hooks/telemetry/`
  - `.claude/telemetry-enabled`
  - the `--structured-telemetry-mcp` flag in `.claude/.planifest-setup-flags`
- The tracked record `planifest-overrides/setup-config/claude-code.md` holds the retired flag and a `backendUrl`.
- `planifest-zero/setup.sh` writes `plan/state/claude-code.md` and removes the old record. Its legacy cleanup removes telemetry wiring.
- `refresh-planifest-zero-dir.ps1` passes the retired `--structured-telemetry-mcp` flag.
- Live references to the old folder name, outside the folder itself:
  - `.github/workflows/planifest.yml`, in a comment on the `windows-powershell` job
  - `planifest-zero/tests/README.md`, in the CI section
  - `docs/decisions-index.md`, which the rename suite exempts as a change record
- `.github/workflows/planifest.yml` still has the `validate-telemetry-schema` job. It posts five-phase events to a telemetry URL when a secret is set.
- The rename suite, `test-0000031-req-001-rename.sh`, fails cases (a) and (b) while the old folder exists.

### Backlog

- 0000097 (open): switch this repo to run its own pipeline on `planifest-zero/`.
- 0000086, 0000089, and 0000093 (superseded): merged into 0000097.
- 0000092: delivered by 0000034, so the 0000097 prerequisite holds.
- 0000108 (open): run the Bash suites in CI. It depends on 0000097.
- Next free backlog ID: 0000109.
