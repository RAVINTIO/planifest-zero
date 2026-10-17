---
title: "Discovery - 0000036-test-runner-coverage"
summary: "Raw P0 discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000036-test-runner-coverage

> Created at the start of P0, before the first coaching question, in every adoption mode.
> Raw findings only; decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so; coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features, and `docs/about.md` exists |
| Git pre-flight | PR #7 merged to `main` as squash commit `986497b`. PR #9 (0000035) is open. Branch `feat/0000036-test-runner-coverage` starts from the PR #9 head |
| Skills inbox | `planifest-framework/skills-inbox/` is empty |

## Mode Findings

### Standard Iterative

- Current version: `0.4.2` on the PR #9 branch, `0.4.1` on `main`
- Prior features (`plan/_archive/`):
  - 0000033-remove-telemetry-mcp (2026-10-16): telemetry removed
  - 0000034-setup-hardening (2026-10-16): retired flags, atomic writes
  - 0000035-powershell-setup-parity (2026-10-17): six hooks on Windows, PowerShell 5.1
- Constraining ADRs (unless superseded):
  - 0000033 ADR-001: `planifest-framework/` is out of scope
  - 0000034 ADR-003: no new test framework without a decision
  - 0000035 ADR-002: `setup.ps1` supports Windows PowerShell 5.1
- Component / data-ownership map (`docs/`): one product component, `planifest-zero`, which owns no data.
- Pending migrations: none.

## Backlog 0000084 findings

- `planifest-zero/tests/run-tests.sh` discovers `test-*.sh` in `tests/` and `tests/regression/`. It never reports a file that misses the glob.
- Non-suite files today: `README.md`, `run-tests.sh`, `helpers/assert.sh`, `regression/regression-manifest.json`, and `test-gate-write-windows.mjs` in both folders, which a `.sh` suite calls.
- No `test-*.ps1` suite exists. No runner path reaches PowerShell.
- 0000033 req-008 checks that each manifest entry names a file on disk. Nothing checks the reverse.
- Tooling: no `pwsh` locally. GitHub's `ubuntu-latest` image includes `pwsh` 7. `windows-latest` includes Windows PowerShell 5.1 and `pwsh` 7.
- CI (`.github/workflows/planifest.yml`) runs on pull requests to `main`. It runs no test suite today.
- `validate-telemetry-schema` in CI guards removed telemetry. Backlog 0000097 covers its removal.
