---
title: "Domain Glossary - workflow-governance-gates"
summary: "Definitions of the workflow governance terms used in this feature."
status: "draft"
version: "0.18.0"
---
# Domain Glossary - workflow-governance-gates

**Skill:** plan
**Feature:** 0000173-workflow-governance-gates
**Version:** 0.18.0

> The ubiquitous language for this feature. If the glossary says "Marker line", the code says `marker line`. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Workflow metric | A count that describes how the workflow ran. The script derives four of them from a run folder. | Metric | ravintio-zero |
| Marker line | A fixed line that a phase agent writes to the build log. The script counts it only at the start of a line or list item. | Marker | ravintio-zero |
| Rework loop | A return to a requirement that the build must fix again. Each rework loop writes a `Rework:` marker line. | Rework | ravintio-zero |
| Governance gate | A report-only check at ship. It compares each workflow metric with its threshold, and it never blocks ship. | Gate | ravintio-zero |
| Threshold | The limit for one workflow metric, held in the thresholds table of the governance standard. | Limit | ravintio-zero |
| Breach | A workflow metric that is above its threshold in a run. The build report and the PR description list each breach. | None | ravintio-zero |
| Loop-state file | A `loop-state-*.md` file in a run folder. It records the state of one loop, and the script reads it for rework counts. | Loop state | ravintio-zero |
| Run folder | The folder that holds one run's artifacts. The script reads its build log and loop-state files from it. | Archive folder | ravintio-zero |
