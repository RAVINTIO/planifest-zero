---
title: "Scope - workflow-governance-gates"
summary: "Boundaries for the workflow metrics script, the thresholds standard, the marker lines, and the ship report."
status: "draft"
version: "0.18.0"
---
# Scope - workflow-governance-gates

**Skill:** plan
**Feature:** 0000173-workflow-governance-gates
**Version:** 0.18.0

## In Scope

- `ravintio-zero/scripts/workflow-metrics.mjs` reads `build-log.md` and every `loop-state-*.md` in a run folder. It prints a Markdown `## Workflow governance` section.
- `ravintio-zero/standards/workflow-governance-standards.md` defines the four metrics, their marker lines, and a thresholds table that the script reads.
- The marker lines are `Rework:`, `Requirement change:`, and `Gate revised:`. The `Blocked:` line keeps its existing form.
- The implement and validate skills write `Rework:` lines. The mid-pipeline change reference writes `Requirement change:` lines.
- Each gate in a gated run writes a `Gate revised:` line when the human asks for a change.
- Ship Step 5 adds the governance section to `build-report.md`. Ship Step 9 adds it to the PR body.
- The pack version moves to 0.18.0, a minor release.

## Out of Scope

- The evaluation suite that runs skills against fixed briefs. Backlog entry 0000174 holds it.
- A blocking gate, and any run-mode switch that turns blocking on.
- Metrics across runs, such as trends over the archive.
- Other backlog entries.

## Deferred

Nothing deferred.
