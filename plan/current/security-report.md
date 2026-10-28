# Security report - 0000252-chart-rules

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/standards/roadmap-standards.md` | none | The change adds chart text only. The guard check makes chart stricter and widens no guard |
| None | `ravintio-zero/templates/initiative.template.md` | none | The new section and row form hold no code. The driver counts rows under `## Steps` only |
| None | `ravintio-zero/skills/ravintio-initiative/SKILL.md` | none | The added bullets name the same rules as the standard and grant no new permission |
| None | `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-session-commands.md` | none | The added paragraph makes a step session stop more often, not less |
| None | `ravintio-zero/tests/test-0000252-req-*.sh` | none | The tests read repo files and write nothing |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding. Risks R-001 to R-004 in the risk register are mitigated.

**Top actions before production.** Restart the driver and the watcher after this step merges. The step edits the initiative skill, so the driver stops with a restart line.
