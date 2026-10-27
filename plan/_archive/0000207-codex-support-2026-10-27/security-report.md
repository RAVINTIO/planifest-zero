# Security report - 0000207-codex-support

**Overall risk rating:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The hook command runs `git rev-parse` in the session directory, so a repo-local git config could change the path | `ravintio-zero/setup.sh` (`install_codex_hooks`) | Low | The path ends in a fixed relative file inside the project. The project hooks need `/hooks` trust in Codex before they run. |
| Codex enforces less than Claude Code, so a user may assume a rule is enforced | `ravintio-zero/templates/codex-boot.md` | Low | Setup prints the fallback list and `AGENTS.md` states each rule as an instruction. |

## Checks with no finding

- Injection: the hook command is a fixed string. Setup passes no user input into it.
- Credentials: none read, none written. A scan of the diff for secret patterns found none.
- Path traversal: setup writes only to fixed relative paths under the project root.
- Dependencies: none added.
- Hard Limits 3 and 4: no schema change.

## Risk register

R-001 to R-004 stay open. R-002 is the second finding above.

## Top actions before production

None.
