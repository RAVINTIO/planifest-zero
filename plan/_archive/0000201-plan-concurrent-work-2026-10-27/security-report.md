# Security Report - 0000201-plan-concurrent-work

**Overall risk rating:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Unit names from the plan print in findings | `ravintio-zero/scripts/consistency-check.mjs` check 8 | Low | Each name passes through `cap()`, which cuts it to 200 characters. The script only prints to stdout. |
| The check reads a path from argv | `ravintio-zero/scripts/consistency-check.mjs` | Low | It reads `execution-plan.md` and the other known file names under the given folder only. It writes nothing. |

## Checks with no finding

- Injection: no shell, no `eval`, no query construction. The script uses `node:fs` and `node:path` only.
- Credentials: none read, none written. A scan of the diff for secret patterns found none.
- Path traversal: file names are fixed strings joined to the given folder.
- Dependencies: none added.
- Data exposure: the script prints plan text the caller already owns.

## Risk register

R-001 and R-002 stay open and are not security risks. R-003 stays open.

## Top actions before production

None.
