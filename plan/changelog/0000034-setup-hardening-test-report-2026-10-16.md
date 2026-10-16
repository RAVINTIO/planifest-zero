# Test Report (0000034-setup-hardening, 2026-10-16)

**Feature:** Setup hardening
**Plan date:** 2026-10-16

## 1. Tests Run This Plan (Validate and Accept, P4)

| Test file | Requirement ID(s) | Status |
|-----------|-------------------|--------|
| test-0000034-req-001-retired-flags.sh | req-001 | pass (34 assertions) |
| test-0000034-req-002-exact-tool-name.sh | req-002 | pass (20 assertions) |
| test-0000034-req-003-atomic-settings-writes.sh | req-003 | pass (18 assertions) |
| test-0000034-req-004-missing-node-warning.sh | req-004 | pass (4 assertions) |
| test-0000034-req-005-006-housekeeping.sh | req-005, req-006 | pass (5 assertions) |
| test-0000031-req-004-setup-execution.sh | updated for ADR-001 | pass |
| test-0000033-req-002-setup-sh-telemetry-removal.sh | updated for ADR-001 | pass |
| test-0000033-req-003-setup-ps1-telemetry-removal.sh | updated for ADR-001 | pass |
| test-0000031-req-001-rename.sh | none (pre-existing) | fail, cases (a) and (b), backlog 0000097 |

**Summary:** 50 feature suites run: 49 passed, 1 failed, 0 skipped.

## 2. Regression Pack State

**Total promoted tests:** 14
**Passed:** 14
**Failed:** 0

| Test file | Source feature | Promoted by | Promotion date | Status |
|-----------|---------------|-------------|----------------|--------|
| test-0000034-req-001-retired-flags.sh | 0000034-setup-hardening | agent | 2026-10-16 | pass |
| test-0000034-req-003-atomic-settings-writes.sh | 0000034-setup-hardening | agent | 2026-10-16 | pass |
| 12 earlier entries | earlier features | see `regression-manifest.json` | earlier | pass |

## 3. Newly Promoted Tests (This Feature)

| Test file | Promoted by | Decision rationale |
|-----------|-------------|-------------------|
| test-0000034-req-001-retired-flags.sh | agent | Guards the retired-flag contract that older installs depend on. Promoted under the continuous run. |
| test-0000034-req-003-atomic-settings-writes.sh | agent | Guards the atomic write and its P5 hardening. Promoted under the continuous run. |

## 4. Summary

**Overall test health:** ⚠ Failures present. The one failure predates this feature and backlog 0000097 tracks it.
