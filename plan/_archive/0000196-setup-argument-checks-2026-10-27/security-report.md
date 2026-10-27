# Security report - 0000196-setup-argument-checks

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| `setup.sh` prints an unknown tool name unchanged | `ravintio-zero/setup.sh`, the `Unknown tool` line | Low | Not mitigated. This behaviour predates the feature. `setup.ps1` prints only a plain name. A tool argument that holds a secret reaches the terminal. Out of scope. |
| Retired-flag error never prints what follows the flag | `ravintio-zero/setup.sh` `retired_flag_error`, `ravintio-zero/setup.ps1` `Stop-OnRetiredFlag` | Informational | Mitigated. Both print the flag name only. Tests assert the value is absent. |
| Injection, path traversal, credentials, dependencies | none found | none | No new input is read, no path is built from input, and no dependency joins the pack. |

## Risk register cross-check

- R-001 (consumers that pass a retired flag): open. The error text says what to remove.
- R-002 (shell drift): mitigated by parity assertions in both suites.
- R-003 (`pwsh` absent): mitigated. `pwsh` ran locally and CI runs the PowerShell suites.
- R-004 (message order): accepted.

**Overall risk rating:** low. No critical or high finding.
