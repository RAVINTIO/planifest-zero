---
title: "Discovery - 0000207-codex-support"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000207-codex-support

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` is at 0.28.0 |
| Git pre-flight | `feat/0000207-codex-support` cut from `initiative/0000195-backlog-clearance` (I-C Run) |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.28.0`
- Prior features (`plan/_archive/`): latest is 0000206-chart-time-decisions (2026-10-27)
- Backlog entry for this step: 0000175 (support agent harnesses other than Claude Code, Codex first)
- Setup today: `VALID_TOOLS="claude-code"` in `setup.sh` and `setup.ps1`. Tool config lives in `ravintio-zero/setup/claude-code.{sh,ps1}`. Hook install paths and `.claude/settings.json` wiring are hardcoded in the shared scripts.
- Repo instructions (`ravintio-overrides/instructions/`): git permissions, subagent decomposition, GUTD shorthand, ship push and PR, redundant branch deletion
- Migrations: 0004 and 0005 stay pending, their `Applies when:` conditions are false in this repo
