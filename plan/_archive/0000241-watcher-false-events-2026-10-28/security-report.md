---
title: "Security Report - 0000241-watcher-false-events"
summary: "Security review of the watcher changes."
---
# Security Report - 0000241-watcher-false-events

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000241-watcher-false-events

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| `--since-commit` value reaches `git merge-base` and `git log` | `ravintio-zero/scripts/initiative-watch.mjs` | Low | The argument matches `^[0-9a-f]{4,64}$` and git runs through `spawnSync` with an argument array, so no shell and no option injection |
| Branch name is printed | `ravintio-zero/scripts/initiative-watch.mjs` | Low | Control characters collapse to one space and every line is cut to 500 characters |
| Watcher writes no file | `ravintio-zero/scripts/initiative-watch.mjs` | None | Existing safety tests still pass |

No injection, credential, path traversal, dependency, or data exposure finding. No new dependency.

**Overall risk rating:** low.
**Risk register:** R-001 open (low). R-002 mitigated by the hex check.
**Top actions before production:** none.
