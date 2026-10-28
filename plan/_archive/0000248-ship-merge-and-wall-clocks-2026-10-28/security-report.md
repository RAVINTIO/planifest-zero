# Security report - 0000248-ship-merge-and-wall-clocks

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/scripts/build-log-check.mjs` | none | The script reads one file with `readFileSync` and runs no shell and no `git`. It prints the phase name and a fixed message, and never prints the file's text. A failed read prints one fixed line |
| None | `ravintio-zero/skills/ravintio-ship/SKILL.md`, `ravintio-zero/standards/roadmap-standards.md` | none | The change adds prose that tells an agent to write the PR number as a literal. It touches no hook. `merge-guard` and its test are unchanged, as the branch diff shows |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding. Risks R-001 to R-003 in the risk register are mitigated.

**Top actions before production.** None.
