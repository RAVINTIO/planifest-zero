---
title: "Requirement: req-004 - retire-telemetry-cleanup"
summary: "Setup in both shells drops the legacy telemetry cleanup and keeps the retired-hook list under a neutral name."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - retire-telemetry-cleanup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Source:** US-004
**Priority:** must-have

## User Story

As a consumer, I run setup without the legacy telemetry cleanup, so that setup carries no dead code. (Backlog 0000095)

## Functional Requirements
- Remove `remove_legacy_telemetry_wiring` and its call from `ravintio-zero/setup.sh`.
- Remove `Remove-LegacyTelemetryWiring` and its call from `ravintio-zero/setup.ps1`.
- Rename the module list to a standalone retired-hooks list.
  - In `setup.sh`, define `RETIRED_HOOK_NAMES` with the same ten names and drop `TELEMETRY_HOOK_MODULES`.
  - In `setup.ps1`, define `$RetiredHookNames` as an array with the same ten names and drop `$TelemetryHookModules`.
- `prune_retired_hooks` and `Remove-RetiredHooks` (0000151 ADR-007) keep reading the renamed list and behave as before.
- Remove `TELEMETRY_MCP_MATCHER` and `$TelemetryMcpMatcher`, which only the cleanup used.
- Remove any helper or shared code that only the cleanup used. Keep helpers that other setup code still calls.
- Remove the comment references to the cleanup in both scripts (`setup.sh` lines near 73 and 984, `setup.ps1` lines near 272, 408 and 1217).
- Setup no longer reads or writes telemetry entries in `settings.json`, `.claude/telemetry-enabled`, or `plan/.telemetry-failures` and `plan/.telemetry-receipts`.
- Add a changelog note in the 1.1.0 entry. A pre-0000033 consumer must remove stale telemetry wiring by hand.
- This requirement retires the cleanup decided in 0000033 ADR-002 (`plan/_archive/0000033-remove-telemetry-mcp-2026-10-16/adr/ADR-002-setup-cleans-up-telemetry-wiring.md`). The plan phase records a superseding ADR.

## Test impact

Suites that test the cleanup. Delete each one or rewrite it so it no longer expects cleanup output.

| Suite | Action |
|-------|--------|
| `test-0000033-req-002-setup-sh-telemetry-removal.sh` | Delete. It tests only the `setup.sh` cleanup. |
| `test-0000033-req-003-setup-ps1-telemetry-removal.sh` | Delete. It tests only the `setup.ps1` cleanup. |
| `test-0000033-req-004-upgrade-cleanup.sh` | Delete. It runs the upgrade cleanup end to end. |
| `test-0000034-req-004-missing-node-warning.sh` | Delete. It extracts `remove_legacy_telemetry_wiring` and tests its node warning. |
| `test-0000035-req-002-004-ps1-fixes.sh` | Rewrite. Drop the `Remove-LegacyTelemetryWiring` checks and keep the rest. |
| `test-0000035-req-005-leftover-temp-file.sh` | Rewrite. It finds the cleanup call line by name. |
| `test-0000041-req-001-003-sh-cleanup-and-warning.sh` | Delete. It tests cleanup parse faults and warnings. |
| `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` | Delete. It is the PowerShell twin. |
| `test-0000036-req-004-setup-ps1-install.ps1` | Rewrite. Drop section (e), which expects the removal line. |
| `test-0000039-req-001-003-ps1-setup-hardening.ps1` | Rewrite. Drop the section that expects the cleanup write. |

Suites that mention telemetry for other reasons. Check each one and change it only if it asserts cleanup output.

- `test-0000031-req-004-setup-execution.sh` and `test-0000031-req-001-rename.sh`: no hook directory is created. These stay.
- `test-0000034-req-001-retired-flags.sh`, `test-0000037-req-002-refresh-script-flags.sh`, `test-0000037-req-003-setup-record-move.sh` and `test-0000036-req-004-setup-ps1-flags.ps1`: retired flags. These stay.
- `test-0000037-req-001-drop-telemetry-ci-job.sh` and `test-0000151-req-013-roadmap-telemetry-labels.sh`: unrelated to setup. These stay.
- Other suites that match the word, such as `test-0000016-pipeline-governance.sh` and `test-0000017-*`: confirm in P2 that none asserts cleanup output. The regression copies under `ravintio-zero/tests/regression/` follow their originals, and `regression-manifest.json` drops any deleted suite.

Suites that test pruning. Keep them passing.

- `test-0000151-req-004-prune-retired-hooks.sh` and `.ps1`. Both grep the old name (`^TELEMETRY_HOOK_MODULES=` and the `setup.ps1` list). Change those two asserts to `RETIRED_HOOK_NAMES` and `$RetiredHookNames`.

## Component manifest

`ravintio-zero/component.yml` line 23 says setup retracts "any legacy setup-config record or telemetry wiring on the next run". Update it to name only the legacy setup-config record. Line 36 (roadmap "telemetry labels") is unrelated and stays.

## Acceptance Criteria
- [ ] `grep -n -i "remove_legacy_telemetry_wiring\|Remove-LegacyTelemetryWiring\|TELEMETRY_MCP_MATCHER\|TelemetryMcpMatcher\|TELEMETRY_HOOK_MODULES\|TelemetryHookModules" ravintio-zero/setup.sh ravintio-zero/setup.ps1` returns nothing.
- [ ] A setup run in both shells leaves a telemetry entry in `settings.json`, `.claude/telemetry-enabled`, and `plan/.telemetry-*` untouched and prints no telemetry line.
- [ ] A setup run in both shells still removes a retired hook file from `.claude/hooks/` and its `settings.json` entry, using `RETIRED_HOOK_NAMES` and `$RetiredHookNames`.
- [ ] Every suite passes in CI on all hosts, with the cleanup suites deleted or rewritten as listed above.
- [ ] The 1.1.0 changelog entry states that a pre-0000033 consumer removes stale telemetry wiring by hand.
- [ ] `ravintio-zero/component.yml` no longer claims a telemetry wiring retraction.

## Dependencies
- None on other requirements in this feature.
- Builds on 0000151 ADR-007 (retired-hook pruning).
