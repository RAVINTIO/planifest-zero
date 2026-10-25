---
title: "Discovery - 0000171-faster-setup-ps1-tests"
summary: "Raw discovery-pass findings: what the orchestrator knew before drafting the design."
---
# Discovery - 0000171-faster-setup-ps1-tests

> Raw findings only. Decisions belong in `design.md`, the audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | Branch `feat/0000171-faster-setup-ps1-tests` cut from `roadmap/0000168-backlog-clearance` at `4bbd90b`. Roadmap step, per R-C Run. |
| Skills inbox | `ravintio-zero/skills-inbox/` holds no `SKILL.md` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.15.0`, from 0000170.
- Roadmap `0000168-backlog-clearance` is active at position 3. Step 3 takes backlog entry 0000159 with a patch bump.
- Roadmap schema and dependency tables list `none` for step 3.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). No component owns data.
- Repo instructions (`ravintio-overrides/instructions/`): `custom-001` to `custom-005`.
- Pending migration `0004-ravintio-rename.md` does not apply. This repo is the pack source.
- Strict mode is on (`plan/.orchestrator-strict`).

## Backlog findings

### 0000159: setup.ps1 run time dominates the PowerShell CI suites

- The CI timing lines come from `ravintio-zero/tests/helpers/setup-workspace.ps1`. `Invoke-Setup` prints `[timing] pwsh start-up`, then `[timing] setup.ps1` for the child run.
- The `setup.ps1` figure includes one child host start. CI measured host start-up at about 0.23 s a case, so about 1.67 s of the 1.9 s is setup work.
- Local profile on macOS `pwsh` 7, one fresh install, function times inclusive:

  | Function | Time |
  |----------|------|
  | Script body | 692 ms |
  | `Copy-RavintioSkills` | 427 ms |
  | `Install-EnforcementHooks` | 89 ms |
  | `Invoke-RavintioGuardrails` | 42 ms |
  | Every other function | under 25 ms each |

- `Copy-RavintioSkills` writes 544 files into 13 skill folders. Each file goes through one `Copy-Item`, `Test-Path`, or `New-Item` cmdlet call.
- A benchmark copied the same 540 files in 401 ms with `Copy-Item` and in 49 ms with `[System.IO.File]::Copy`.
- `Copy-Item -Recurse` copies dot files such as `.gitkeep`. The orchestrator skill's `assets/`, `references/`, and `scripts/` folders each hold one.
- `Set-Content -Encoding UTF8` writes a BOM under Windows PowerShell 5.1 and none under `pwsh` 7. The SKILL.md path rewrite uses it.
- The suites hold about 40 `Invoke-Setup` call sites. Most cases prepare their own `settings.json` before setup, so few cases share a starting state.
- `run-tests.ps1` prints no timing total. The 0000151 figures came from summing the log lines by hand.
