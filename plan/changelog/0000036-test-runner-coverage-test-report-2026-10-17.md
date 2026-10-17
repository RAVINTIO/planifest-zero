# Test Report (0000036-test-runner-coverage, 17 Oct 2026)

## Tests Run

| Where | Suite set | Passed | Failed | Skipped |
|-------|-----------|--------|--------|---------|
| Local, macOS | Feature suites | 55 | 1 | 2 PowerShell, no `pwsh` |
| Local, macOS | Regression suites | 16 | 0 | 0 |
| CI, Windows PowerShell 5.1 | PowerShell suites | 2 | 0 | 0 |
| CI, PowerShell 7 | PowerShell suites | 2 | 0 | 0 |

The one local failure is `test-0000031-req-001-rename.sh`, cases (a) and (b). It fails while `planifest-framework/` exists, and backlog 0000097 tracks it.

New suites:

| Suite | Assertions |
|-------|-----------|
| `test-0000036-req-001-003-runner.sh` | 19 |
| `test-0000036-req-005-windows-ci-job.sh` | 10 |
| `test-0000036-req-004-setup-ps1-install.ps1` | 18 |
| `test-0000036-req-004-setup-ps1-flags.ps1` | 16 |

## Regression Pack State

16 suites after this feature's promotion.

## Newly Promoted Tests

- `test-0000036-req-001-003-runner.sh`, promoted under the continuous run.
