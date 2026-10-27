# Security Report - 0000203-blameless-postmortems

**Overall risk rating:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| A postmortem record could copy a credential or a person's name from a log | `ravintio-zero/skills/ravintio-postmortem/SKILL.md` | Low | Rule 3 forbids copying secrets and names the file and line instead. Rule 1 forbids naming a person. Log text is treated as data. |

## Checks with no finding

- Injection: no script, shell, or query changed.
- Credentials: none read, none written. A scan of the diff for secret patterns found none.
- Dependencies: none added.

## Risk register

R-001, R-002, and R-003 stay open. R-003 is the credential risk above.

## Top actions before production

None.
