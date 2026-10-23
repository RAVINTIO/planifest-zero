# Decisions Index

> Change record. Index of all ADRs across all features. Updated after every pipeline run.
> Do not archive this file. Update it in place.

Last updated: 0000041-setup-cleanup-and-park-hardening

---

## Note on the reset

Feature 0000030 emptied `plan/_archive/`, so the ADR files for features 0000001 through 0000029 no longer exist in the working tree. They remain in git history.

This index restarts from 0000030. Decisions from earlier features still bind where their subject survives, but the ADR text has to be read from history.

---

## All Architecture Decision Records

### Feature 0000030: framework-cut-down

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Claude Code is the only supported tool target | accepted | Drops eight tool targets, the vendored external skill library, and the context-mode integration. Supersedes 0000001 ADR-001 to ADR-004. |

### Feature 0000031: five-phase-planifest-zero

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Five-phase pipeline contract and skill consolidation | accepted | Collapses the ten-phase pipeline to five phases (discovery, plan, implement, validate and accept, ship) and 21 skills to 12. |
| ADR-002 | Folder rename and product identity | accepted | Renames `planifest-framework/` to `planifest-zero/`, sets the `product.yml` id to `planifest-zero`, and fixes the Windows refresh script to derive its own path. |
| ADR-003 | One route: the feature pipeline | accepted | Drops the Change Pipeline and Fast Path routes. Every change runs the five-phase feature pipeline, and one CI parity check applies to every diff. |
| ADR-004 | Living docs describe the present only | accepted | Moves historical narrative to change records: `plan/changelog/`, `plan/_archive/`, ADR files, and git history. This index and `docs/about.md` carry stated exemptions. |

### Feature 0000032: relocate-setup-config-to-plan-state

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The setup-config record lives in plan/state/ | accepted | Moves the tracked setup-flags record from `planifest-overrides/setup-config/{tool}.md` to `plan/state/{tool}.md`. Supersedes 0000025 ADR-002. |
| ADR-002 | Refresh-setup reads the record before the marker | accepted | `planifest-refresh-setup` Step 3 reads `plan/state/{tool}.md` first at high confidence, falling back to the gitignored marker then hook inference. |
| ADR-003 | Setup removes the old record inline | accepted | `setup.sh` and `setup.ps1` delete the pre-relocation record at its exact path after a successful write, with no separate migration file. |

### Feature 0000033: remove-telemetry-mcp

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Telemetry is not a pack concern | accepted | Removes the telemetry system from `planifest-zero` with no replacement and no extension seam. Drops `backendUrl` from the setup-config record, narrowing 0000032 ADR-001. |
| ADR-002 | Setup cleans up telemetry wiring on every run | accepted | Every setup run removes legacy telemetry hook entries, the opt-in sentinel, and the marker directories. One line per removal, a warning without failing. |
| ADR-003 | The phase vocabulary lives in prose, not in a module | accepted | Deletes `phase-enum.mjs` and states the five phase names in `pipeline-reference.md`. The `product.yml` id and its hard stop stay, for versioning. |

---

## Superseded

| ADR | Superseded by | Reason |
|-----|---------------|--------|
| 0000001 ADR-001 to ADR-004 | 0000030 ADR-001 | The context-mode hook design they governed no longer exists. |
| 0000025 ADR-002 | 0000032 ADR-001 | The record moved from planifest-overrides/setup-config/ to plan/state/. The ADR text is in git history only. |
| 0000018, 0000024, 0000026, 0000027, and 0000028 telemetry ADRs | 0000033 ADR-001 | Their subject no longer exists in `planifest-zero`. The ADR text is in git history only. |
| 0000024 product-id ADR (rationale only, partly superseded) | 0000033 ADR-003 | The `id` field and the hard stop stand. Versioning and archive attribution replace telemetry attribution as the reason. |
| 0000032 ADR-001 (record shape only, narrowed) | 0000033 ADR-001 | The record drops `backendUrl` and holds `tool`, `flags`, and `writtenAt`. Its location and tracked status stand. |
| 0000036 ADR-003 (Bash suites out of CI only, narrowed) | 0000037 ADR-002 | The `bash-suites` job runs the Bash suites in CI. The Windows job stands. |
| 0000037 ADR-003 (decision item 4 only, narrowed) | 0000041 ADR-003 | The non-array warning no longer prints the old value. Warn, replace, and exit 0 stand. |

### Feature 0000034: setup-hardening

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Retired setup flags warn and continue | accepted | Setup accepts four retired flags with one warning each and skips the `--backend-url` value. Supersedes the no-op rejection in 0000030 ADR-001. |
| ADR-002 | settings.json writes go through a temporary file and a rename | accepted | Every `settings.json` write uses a same-folder temporary file, keeps the original's mode, and never follows a planted link. |
| ADR-003 | The stack stays as it is | accepted | No new language, runtime, or test framework. |


### Feature 0000035: powershell-setup-parity

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | setup.ps1 writes the same hook entries as setup.sh | accepted | `setup.ps1` wires all six enforcement hooks in the `setup.sh` entry shape, and a static parity suite checks the match. |
| ADR-002 | setup.ps1 supports Windows PowerShell 5.1 | accepted | `setup.ps1` uses no PowerShell 7-only feature, so it runs on the PowerShell that ships with Windows. |
| ADR-003 | setup.ps1 flags are case-sensitive | accepted | The flag `switch` matches case, as `setup.sh` does. Both scripts remove a leftover temporary file at the start of each run. |

### Feature 0000036: test-runner-coverage

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | Stray test files fail the run | accepted | `run-tests.sh` names every file under `tests/` that is neither a suite nor a known non-suite, and exits 1. |
| ADR-002 | PowerShell suites use a plain assert helper | accepted | `test-*.ps1` suites use `helpers/assert.ps1` with no Pester. `run-tests.sh` runs them with `pwsh` or reports the skip. |
| ADR-003 | CI runs the PowerShell suites on Windows under both hosts | accepted | A `windows-latest` job runs `run-tests.ps1` with `powershell` and with `pwsh`. Bash suites stay out of CI for now. |

### Feature 0000037: self-host-on-planifest-zero

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The repo self-hosts on planifest-zero | accepted | Repoints `core.hooksPath` to `planifest-zero/hooks`, then deletes `planifest-framework/`. The setup record moves to `plan/state/claude-code.md`. |
| ADR-002 | The Bash suites run in CI on Ubuntu | accepted | A `bash-suites` job runs `run-tests.sh` with `PLANIFEST_REQUIRE_PWSH=1` and `contents: read`. The `validate-telemetry-schema` job goes. |
| ADR-003 | Setup repairs the hook entries it owns | accepted | `setup.sh` removes Planifest `PreToolUse` entries on any matcher. Both scripts warn on a non-array hook event and replace it. |
| ADR-004 | P0 states standard-iterative mode without asking | accepted | When standard-iterative is the only signal, the orchestrator states the mode and its signal. Every other case keeps the question. |

### Feature 0000038: setup-hook-filter-fixes

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or test framework. |
| ADR-002 | Setup filters Planifest hook commands one at a time | accepted | Both scripts remove only Planifest commands from a `PreToolUse` or `UserPromptSubmit` entry and keep user commands. `setup.sh` matches `UserPromptSubmit` by path boundary. Refines 0000037 ADR-003. |

### Feature 0000039: setup-hardening-release-sizing

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | Invalid JSON exits 1 with a fixed message | accepted | The hook install step prints one fixed line naming the file, leaves it unchanged, and exits 1. The telemetry cleanup still warns and carries on. |
| ADR-003 | A single-object `hooks` value counts as a one-item array | accepted | Both scripts apply the per-command filter to a single-object `hooks` value. Refines 0000038 ADR-002. |
| ADR-004 | The release budget lives in `product.yml` | accepted | An optional `releaseSize` field sets a budget of 4, 8, or 14 points, with `medium` as the default. It replaces the fixed 3-story rule. |

### Feature 0000040: setup-json-checks-and-park

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | Valid JSON that is not a settings object exits 1 | accepted | Both scripts print one shared fixed line, leave the file unchanged, and exit 1. Extends 0000039 ADR-002. |
| ADR-003 | Only `setup.ps1` rejects case-duplicate keys | accepted | `ConvertFrom-Json` can't read them, so `setup.ps1` gives the shared line. `setup.sh` accepts them. |
| ADR-004 | JSON depth is capped at 1024 | accepted | `Test-JsonText` uses a counter and a `Stack[char]`, runs in linear time, and fails past 1024 levels. |
| ADR-005 | Park keeps the work on the feature branch | accepted | Park pushes the branch and files a `parked` backlog entry by chore PR. Pickup resumes or discards it. |

### Feature 0000041: setup-cleanup-and-park-hardening

| ADR | Title | Status | Summary |
|-----|-------|--------|---------|
| ADR-001 | The stack stays as it is | accepted | No new language, runtime, or dependency. |
| ADR-002 | The telemetry cleanup skips unreadable settings | accepted | Both cleanups skip in silence on a parse or shape failure. The hook install step reports the fault once. Extends 0000033 ADR-002. |
| ADR-003 | The non-array warning drops the old value | accepted | Both scripts name the event and the file only. Supersedes decision item 4 of 0000037 ADR-003. |
