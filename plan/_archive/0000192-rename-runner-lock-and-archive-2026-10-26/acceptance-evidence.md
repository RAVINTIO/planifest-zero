# Acceptance Evidence - 0000192-rename-runner-lock-and-archive

## Checks

| Check | Result |
|-------|--------|
| Semantic coverage | 8 of 8 acceptance criteria map to an executing test. Three tests name a 0000192 requirement. Five reuse existing driver and guard tests, updated to the new names. |
| Bash suites (macOS) | 165 feature and 19 regression suites pass |
| PowerShell suites (pwsh 7) | 16 pass |
| Consistency check | clean |
| Old-name guard | 0 old names outside the allowlist |
| Self-correction cycles | 0 |

## Security

Overall low. Two low findings, no critical, high, or medium ones. See `security-report.md`.

- During one upgrade, old and new drivers hold different lock files (`ravintio-zero/scripts/initiative-run.mjs:76`).
- The delivery check builds prefixes from the id and slug, but builds no path from them.

## Execution evidence

The driver ran in scratch repos with a stub `claude`:

- It held `plan/.initiative-runner.lock` during a step, released it at exit 0, and excluded it once.
- A held lock stopped a second driver with exit 1. The lock contents stayed unchanged, and no step ran.
- An archive folder in either the `-initiative-` or the `-roadmap-` form ended the run with `I-E Delivery: Complete:`.

No criterion is `not-verifiable`.

## Coverage

| Criterion | Test |
|-----------|------|
| REQ-001 AC-1 | `test-0000043-req-007-roadmap-driver.sh` (a), (c) |
| REQ-001 AC-2 | `test-0000043-req-007-roadmap-driver.sh` (b) |
| REQ-001 AC-3 | `test-0000043-req-007-roadmap-driver.sh` (d), `test-0000151-req-012-roadmap-step-logs.sh` (b) |
| REQ-002 AC-1 | `test-0000043-req-008-roadmap-delivery.sh` (a) |
| REQ-002 AC-2 | `test-0000043-req-007-roadmap-driver.sh` 0000192 req-002 AC-2 |
| REQ-002 AC-3 | `test-0000043-req-007-roadmap-driver.sh` 0000192 req-002 AC-3 |
| REQ-003 AC-1 | `test-0000189-req-007-old-name-guard.sh` AC-1 |
| REQ-003 AC-2 | `test-0000189-req-007-old-name-guard.sh` 0000192 req-003 AC-2 |
