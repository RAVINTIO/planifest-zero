# Test Report (0000035-powershell-setup-parity, 17 Oct 2026)

## Tests Run (P4, re-run after P5)

| Suite set | Passed | Failed |
|-----------|--------|--------|
| Feature suites | 53 | 1 |
| Regression suites | 14 | 0 |

The one failure is `test-0000031-req-001-rename.sh`, cases (a) and (b). It fails while `planifest-framework/` exists, and backlog 0000097 tracks it. It failed before this feature.

New suites:

| Suite | Assertions |
|-------|-----------|
| `test-0000035-req-001-hook-parity.sh` | 17 |
| `test-0000035-req-002-004-ps1-fixes.sh` | 8 |
| `test-0000035-req-005-leftover-temp-file.sh` | 12 |
| `test-0000035-p5-security-fixes.sh` | 19 |

No `pwsh` exists locally or in CI, so every `setup.ps1` check is static.

## Regression Pack State

15 suites after this feature's promotion.

## Newly Promoted Tests

- `test-0000035-req-001-hook-parity.sh`, promoted under the continuous run.
