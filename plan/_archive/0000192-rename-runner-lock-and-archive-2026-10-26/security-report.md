# Security Report - 0000192-rename-runner-lock-and-archive

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| During one upgrade, a driver on the old pack and a driver on the new pack hold different lock files, so neither blocks the other. | `ravintio-zero/scripts/initiative-run.mjs:76` | Low | Design assumption A-001: no driver runs during an upgrade. The window closes once both sides run the new pack. Not mitigated in code. |
| The delivery check builds folder prefixes from the initiative id and slug. | `ravintio-zero/scripts/initiative-run.mjs` `delivered()` | Low | The values only feed `startsWith` on names from `readdirSync`. No path is built from them, so no traversal is possible. Mitigated. |

- **Injection points:** none new. No shell, query, or template takes new input.
- **Credential handling:** no credentials touched.
- **Path traversal:** none. See the second finding.
- **Dependency risk:** no new dependency.
- **Data exposure:** none. The lock holds the driver's pid only, as before.

## Overall risk rating

Low. No critical, high, or medium findings.

## Risk register cross-reference

| Risk | Status |
|------|--------|
| R-001 missed reference to the old lock | Mitigated: the guard finds 0 old names, and the lock tests pass. |
| R-002 delivery check misses an old archive folder | Mitigated: a driver test and an execution check cover each form. |
| A-001 no driver during upgrade | Open, low impact. See the first finding. |

## Top actions before production

- None required.
