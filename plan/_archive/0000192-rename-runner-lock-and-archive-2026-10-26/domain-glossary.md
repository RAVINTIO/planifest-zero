---
title: "Domain Glossary - rename-runner-lock-and-archive"
summary: "Definitions of the runner lock and the delivery archive folder."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - rename-runner-lock-and-archive

**Skill:** plan
**Feature:** 0000192-rename-runner-lock-and-archive
**Version:** 0.19.0

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Runner lock | The file the initiative driver holds while it runs: `plan/.initiative-runner.lock`. It stops a second driver. | the old `roadmap-runner` lock (retired) | ravintio-zero |
| Delivery archive folder | The folder I-E Delivery moves a delivered initiative to: `plan/_archive/{id}-{slug}-initiative-{date}/`. | the old `-roadmap-` form (older folders keep it) | ravintio-zero |
| Delivery check | The driver test that reports an initiative delivered once its archive folder exists. | `delivered()` | ravintio-zero |
