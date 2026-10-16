# Test Report (0000033-remove-telemetry-mcp, 2026-10-16)

**Feature:** Remove telemetry from planifest-zero
**Plan date:** 2026-10-16

## 1. Tests Run This Plan (P4 Results)

Every functional requirement appears here.

| Test file | Requirement ID(s) | Status |
|-----------|-------------------|--------|
| Enforcement suites (4) plus `node --check` on the 7 surviving hook modules | req-001 | pass (72 cases) |
| `test-0000033-req-002-setup-sh-telemetry-removal.sh` | req-002 | pass (40 cases) |
| `test-0000033-req-003-setup-ps1-telemetry-removal.sh` | req-003 | pass (25 cases, static) |
| `test-0000033-req-004-upgrade-cleanup.sh` | req-004 | pass (57 cases) |
| `test-0000031-req-001-rename.sh` case (c) | req-005 | pass (6 cases) |
| Rewritten skill and template suites, verified against the 12 skills | req-006 | pass |
| `self-description-check.mjs` and the docs `grep` | req-007 | pass (verified by inspection plus script) |
| `test-regression-pack.sh` manifest check and 16 rewritten suites | req-008 | pass |

**Summary:** 122 assertions across the three new suites, all passing. The P5 security fix added 6
of them through a RED then GREEN cycle.

Full runner: 44 feature suites passed, 1 failed. Regression pack: 12 passed, 0 failed. Suite
arithmetic reconciles: 57 baseline, minus 20 deleted, plus 3 new, equals 45.

The failing suite is `test-0000031-req-001-rename.sh`, on cases (a) and (b) only. Both assert that
no `planifest-framework/` folder exists, which PR #4 reversed on purpose. Both fail on `main` as well.
Backlog 0000086 records the decision needed. The human authorised the pipeline to continue at P4.

req-003 and the P5 PowerShell fixes have static assertions only, because `pwsh` is not installed and
no PowerShell suite runs through `run-tests.sh`. Backlog 0000084 covers that gap.

## 2. Regression Pack State

**Total promoted tests:** 12 suites under `planifest-zero/tests/regression/`
**Passed:** 12
**Failed:** 0

This feature pruned 5 stale entries from `regression-manifest.json`. It also added a check that
every manifest entry names a file on disk, so a missing suite no longer passes silently.

## 3. Newly Promoted Tests (This Feature)

None. No test file produced during P3 or P4 carried a `# REGRESSION-CANDIDATE:` tag, so P7's
regression confirmation had nothing to present. The three new suites stay in the per-feature set.
