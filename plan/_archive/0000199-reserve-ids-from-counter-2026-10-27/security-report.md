# Security report - 0000199-reserve-ids-from-counter

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The script writes to a path from `--file` | `ravintio-zero/scripts/reserve-id.mjs` | Low | Accepted. An agent or the human runs it with a path they choose, as with any pack script. It writes only that file, its `.lock`, and a `.tmp-{pid}` file beside it. |
| Symlinked counter or lock | `reserve-id.mjs`, `isSymlink()` | Informational | Mitigated. The script exits 1 on a symlink at either path and writes nothing. The temporary file opens with `wx`, so it never follows a planted link. |
| Partial write | `reserve-id.mjs`, `writeCounter()` | Informational | Mitigated. The script writes a temporary file and renames it over the counter. |
| Stale lock blocks reservation | `plan/backlog/.next-id.lock` | Low | Accepted. The script waits 5 seconds, exits 1, and names the lock. It never removes a lock it did not take, so it fails closed. |
| `--init` scan reads folder names | `highestId()` | Informational | Mitigated. It reads names only, matches seven digits, and treats nothing as instructions. |
| Injection, credentials, dependencies | none found | none | The script uses Node built-ins, runs no shell, and reads no secret. No dependency joins the pack. |

## Risk register cross-check

- R-001 (stale lock): accepted. The script names the lock for the human.
- R-002 (two branches reserve the same ids): accepted. Git shows a conflict and the docs state the answer.
- R-003 (a doc keeps the scan rule): mitigated. The new suite searches the six docs.
- R-004 (write failure truncates the counter): mitigated. The script renames a temporary file over the counter.

**Overall risk rating:** low. No critical or high finding.
