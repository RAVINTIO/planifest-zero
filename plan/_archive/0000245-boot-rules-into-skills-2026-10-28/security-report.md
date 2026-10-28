# Security report - 0000245-boot-rules-into-skills

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| A `target:` value could write outside the skills folder | `ravintio-zero/setup.sh` `override_target`, `ravintio-zero/setup.ps1` `Get-OverrideParts` | Medium | The value must match `^[a-z0-9][a-z0-9-]*$` and name a regular `SKILL.md` in a non-symlink skill folder. A traversal fixture (`../x`) leaves the file untouched. Mitigated |
| `.claude/skills/` was emptied during the step, cause unknown | `.claude/skills/.ravintio-manifest` | Low | Filed as backlog entry 0000262. The folder is git-ignored and regenerable. Not mitigated in this feature |
| Hook message edits could change a block decision | `ravintio-zero/hooks/enforcement/*.mjs`, `ravintio-zero/hooks/commit-msg` | Low | The edits change message text only. `test-0000245-req-001` asserts each exit code. Mitigated |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding. Risks R-001 and R-002 in the risk register are mitigated.

**Top actions before production.** Resolve entry 0000262.
