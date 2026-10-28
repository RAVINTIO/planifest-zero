# Security report - 0000249-check-path-before-missing-claims

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` | none | The change adds prose that tells an agent to run `command -v` and look in three folders. It adds no script, hook, or shell call. The evidence rule records the command and a found or not-found result, and the section keeps its ban on raw command output |
| None | `ravintio-zero/tests/test-0000249-req-001-path-check-and-docs-only-status.sh` | none | The test reads one file and runs no network or shell command beyond `awk` |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding. Risks R-001 to R-003 in the risk register are mitigated.

**Top actions before production.** None.
