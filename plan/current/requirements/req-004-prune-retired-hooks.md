---
title: "Requirement: req-004 - prune-retired-hooks"
summary: "Setup deletes installed hooks named on the retired list and never deletes a hook absent from it."
status: "draft"
version: "0.1.0"
---
# Requirement: req-004 - prune-retired-hooks

**Skill:** [plan](../../../planifest-zero/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-004 (backlog 0000143)
**Priority:** should-have

## User Story

As a maintainer, I rerun setup and lose installed hooks that the pack retired, so that stale hooks stop running.

## Functional Requirements
- Setup copies hooks into `.claude/hooks/` but never removes one. Three installed files have no source: `check-telemetry-failures.mjs`, `check-telemetry-receipts.mjs`, and `phase-enum.mjs`.
- The retired list is `TELEMETRY_HOOK_MODULES` at `planifest-zero/setup.sh:311`, mirrored as `$TelemetryHookModules` near `setup.ps1` lines 569-581. `phase-enum` is missing from both. Add it.
- After the hooks copy (`setup.sh` near lines 433-440, `setup.ps1` near lines 697-701), setup deletes each installed hook whose base name is on the retired list.
  - Setup checks the `.claude/hooks/` tree, including `enforcement/`.
  - Setup prints one line per removal, naming the relative path.
  - Setup never deletes a hook that is absent from the retired list, even when the pack source no longer has it.
  - If no listed hook is installed, setup prints no removal line and exits as before.
- `setup.sh` and `setup.ps1` use the same list contents and the same output line.
- No `settings.json` entry may reference a pruned file. The existing legacy wiring removal already drops entries that name a listed module. Setup confirms that `phase-enum` is covered by it.
- `.claude/hooks` is gitignored, so the change touches only the local install and no tracked file.

## Acceptance Criteria
- [ ] (a) Setup prunes the retired hooks. All of these hold:
  - Given an installed `.claude/hooks/enforcement/phase-enum.mjs`, `check-telemetry-failures.mjs`, and `check-telemetry-receipts.mjs`, `setup.sh` deletes all three and prints one removal line each.
  - The `setup.ps1` equivalent test deletes the same three files and prints the same lines.
  - A second setup run prints no removal line.
  - `phase-enum` appears in the retired list of both `setup.sh` and `setup.ps1`.
- [ ] (b) Setup keeps every other hook and leaves no stale settings entry. All of these hold:
  - A hook file that is not on the retired list, such as `custom-local-hook.mjs`, survives both setup scripts.
  - Every hook that the pack still ships is present after setup and is not named in any removal line.
  - Given a `settings.json` entry that references `phase-enum`, after setup no entry in `settings.json` references any pruned file.
- [ ] (c) Existing tests still pass. All of these hold:
  - The existing hook-parity and cleanup tests (`test-0000035-req-001-hook-parity.sh`, `test-0000033-req-004-upgrade-cleanup.sh`, `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1`) pass unchanged.

## Dependencies
- REQ-005 also edits `setup.sh` and `setup.ps1`. The two requirements touch different functions, but they share the files.
- Files in reach:
  - `planifest-zero/setup.sh` (retired list at line 311, hooks copy near lines 433-440)
  - `planifest-zero/setup.ps1` (retired list near lines 569-581, hooks copy near lines 697-701)
  - `planifest-zero/tests/test-0000151-req-004-prune-retired-hooks.sh` (new)
  - `planifest-zero/tests/test-0000151-req-004-prune-retired-hooks.ps1` (new, for the `setup.ps1` side)
  - `planifest-zero/tests/test-0000033-req-004-upgrade-cleanup.sh` (existing, check only)
