# Test Report (0000037-self-host-on-planifest-zero, 2026-10-17)

**Feature:** self-host-on-planifest-zero
**Plan date:** 2026-10-17

## 1. Tests Run This Plan (Validate and Accept, P4)

| Test file | Requirement ID(s) | Status |
|-----------|-------------------|--------|
| `test-0000037-req-001-drop-telemetry-ci-job.sh` | req-001 | pass |
| `test-0000037-req-002-refresh-script-flags.sh` | req-002 | pass |
| `test-0000037-req-003-setup-record-move.sh` | req-003 | pass |
| `test-0000037-req-004-remove-old-framework.sh` and `test-0000031-req-001-rename.sh` | req-004 | pass |
| `test-0000037-req-005-override-phase-names.sh` | req-005 | pass |
| `test-0000037-req-006-bash-suites-ci-job.sh` and the `bash-suites` CI job | req-006 | pass |
| `test-0000037-req-007-sh-filter-any-matcher.sh` | req-007 | pass |
| `test-0000037-req-008-non-array-hook-events.sh` | req-008 | pass |
| `test-0000037-req-008-non-array-hook-events.ps1` | req-008 | pass in CI on Windows PowerShell 5.1, PowerShell 7, and Linux `pwsh`. Skipped locally, because `pwsh` isn't installed. |
| `test-0000037-req-009-assume-standard-iterative.sh` | req-009 | pass |

**Summary:** The local run passes 65 feature suites and 18 regression suites, with 0 failures. It skips 3 PowerShell suites, because `pwsh` isn't installed locally. On PR #12, all four CI jobs pass at `87d67ec`, and `bash-suites` requires `pwsh`.

Before this run, the local run had 1 failing suite, the rename suite. It now passes all 13 checks.

## 2. Regression Pack State

**Total promoted tests:** 18
**Passed:** 18
**Failed:** 0

The full list is in `planifest-zero/tests/regression/regression-manifest.json`.

## 3. Newly Promoted Tests (This Feature)

| Test file | Promoted by | Decision rationale |
|-----------|-------------|-------------------|
| `test-0000037-req-007-sh-filter-any-matcher.sh` | human | It guards the `PreToolUse` merge rule, which wired `gate-write` twice before. |
| `test-0000037-req-008-non-array-hook-events.sh` | human | It guards setup against hand-edited, non-array hook events. |

## 4. Summary

**Overall test health:** ✅ Healthy

P4 needed one self-correction. Three older suites failed on Linux because of GNU and BSD tool differences. The fix made them portable.
