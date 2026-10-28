# Security report - 0000247-git-state-hygiene

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/scripts/reserve-id.mjs` | none | `--commit` calls `git` through `execFileSync` with an argument array and no shell. The counter path follows `--`, so a path that starts with a dash is never read as an option. The existing symlink refusal on the counter and the lock still apply |
| None | skills, standard, and tests | none | The change adds prose and read-only tests. It touches no hook, `merge-guard`, or `gate-write` |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding. Risks R-001 to R-003 in the risk register are mitigated.

**Top actions before production.** None.
