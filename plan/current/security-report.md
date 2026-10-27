# Security report - 0000197-merge-guard-block-message

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| Control flow of the hook is unchanged | `ravintio-zero/hooks/enforcement/merge-guard.mjs`, `parsePlain()` and `evaluate()` | Informational | Mitigated. The diff adds one constant and appends it to three reason strings. The exit codes in the existing suite are identical. |
| Message text is static | `ravintio-zero/hooks/enforcement/merge-guard.mjs`, `WRITE_ADVICE` | Informational | Mitigated. No command text enters a message, so the new text cannot echo input. |
| Injection, path traversal, credentials, dependencies | none found | none | No new input is read, no path is built from input, and no dependency joins the pack. |

## Risk register cross-check

- R-001 (message edit weakens the guard): mitigated. The existing suite and the new AC-3 assertions prove the same exits.
- R-002 (consumer matches old text): accepted. No pack file matched the old text.
- R-003 (malformed real call shows the text reason): accepted. The text stays accurate.

**Overall risk rating:** low. No critical or high finding.
