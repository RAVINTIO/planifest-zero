---
title: "Domain Glossary - subagent-acceleration"
summary: "Definitions of the run speed, fast batch, wall-clock time, and run mode terms used in this feature."
status: "draft"
version: "0.17.0"
---
# Domain Glossary - subagent-acceleration

**Skill:** plan
**Feature:** 0000172-subagent-acceleration
**Version:** 0.17.0

> The ubiquitous language for this feature. If the glossary says "Run speed", the code says `run speed`. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Run speed | The value in `plan/.run-speed`. It is `fast` or `standard`. A missing or unknown value counts as `standard`. | Speed setting | ravintio-zero |
| Fast batch | The work units that a phase skill lists. A fast run dispatches them in one message. Phases still run in order. | Batch | ravintio-zero |
| Wall-clock time | The elapsed time from a phase block's `Start` to its `End`, in whole minutes. The build log records it for each phase. | Phase duration | ravintio-zero |
| Run mode | The gate setting in `plan/.run-mode`. It is `gated` or `autonomous`. This feature does not change it. | None | ravintio-zero |
