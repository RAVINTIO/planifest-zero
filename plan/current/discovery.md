---
title: "Discovery - 0000253-refresh-setup"
summary: "Raw discovery-pass findings for initiative 0000238 step 15."
---
# Discovery - 0000253-refresh-setup

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `src/` or the component pack exists beside it |
| Git pre-flight | Branch `feat/0000253-refresh-setup` cut from `initiative/0000238-backlog-clearance-two` (I-C Run) |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.40.0`
- Prior features (`plan/_archive/`): latest is 0000252-chart-rules (2026-10-28), step 14 of this initiative
- Constraining ADRs: none that bear on a setup refresh
- Component / data-ownership map: one component, `ravintio-zero`
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, `custom-006`. Only `custom-006` bears on this step.
- Chore: run `ravintio-refresh-setup` with `ravintio-zero/setup.sh claude-code --strict-orchestrator`, then confirm `.claude/skills/` matches `ravintio-zero/skills/`.
- Flag source: `plan/state/claude-code.md` holds `["--strict-orchestrator"]`. `plan/.orchestrator-strict` exists.
