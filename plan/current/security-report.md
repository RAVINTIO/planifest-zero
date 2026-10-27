# Security report - 0000198-cap-echoed-plan-text

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| Control flow of the ratchet is unchanged | `ravintio-zero/hooks/enforcement/ratchet-check.mjs`, `capLine()` and the `removed:` map | Informational | Mitigated. The diff adds one function and one constant and wraps one string. The block set and exit codes match the existing suites. |
| Control flow of the consistency check is unchanged | `ravintio-zero/scripts/consistency-check.mjs`, `cap()` and the `label` assignment | Informational | Mitigated. The label feeds only two finding strings. |
| Echoed text is now bounded | Both programs | Informational | Mitigated. This closes the two low findings from 0000170. The new suite feeds a 1000-character line to each program. |
| Installed hook copy stays uncapped until setup runs | `.claude/hooks/enforcement/ratchet-check.mjs` | Low | Accepted. The copy is local and gitignored. Step 13 of initiative 0000195 refreshes it. |
| Injection, path traversal, credentials, dependencies | none found | none | No new input is read, no path is built from input, and no dependency joins the pack. |

## Risk register cross-check

- R-001 (cap edit changes the block set): mitigated. The existing suites and the exit code assertions prove the same exits.
- R-002 (cut splits a surrogate pair): mitigated. The cut counts code points and the suite tests the boundary.
- R-003 (a test asserts an uncapped line): mitigated. No existing test asserted one.
- R-004 (installed hook stays uncapped): accepted. Step 13 refreshes it.

**Overall risk rating:** low. No critical or high finding.
