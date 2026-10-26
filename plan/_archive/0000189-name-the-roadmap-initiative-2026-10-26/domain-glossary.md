---
title: "Domain Glossary - name-the-roadmap-initiative"
summary: "Definitions of the roadmap, roadmap initiative, initiative state, and naming terms used in this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - name-the-roadmap-initiative

**Skill:** plan
**Feature:** 0000189-name-the-roadmap-initiative
**Version:** 0.19.0

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Roadmap | The long-term plan for the product. `plan/roadmap/` holds it, with one subfolder per roadmap initiative. | None | ravintio-zero |
| Roadmap initiative | A goal that delivers a string of feature builds. Each build merges into the initiative's branch, and that branch merges to `main` in one PR. | `initiative`. The older alias `roadmap` for the charted unit is retired. | ravintio-zero |
| Proposed | The initiative is drafted in `plan/roadmap/` but not charted. | Proposed state | ravintio-zero |
| Charted | I-A Chart approved the step table. | Charted state | ravintio-zero |
| Active | I-B Activate cut the branch and moved the file to `plan/current-initiative/`. | Active state | ravintio-zero |
| Delivered | I-E Delivery raised the PR to `main`. | Delivered state | ravintio-zero |
| Blocked | A stop halted the run. | Blocked state | ravintio-zero |
| Initiative branch | The branch that holds an initiative's feature builds, named `initiative/{id}-{slug}`. | `roadmap/{id}-{slug}` (retired) | ravintio-zero |
| Initiative driver | The script that runs an initiative's steps: `ravintio-zero/scripts/initiative-run.mjs`. | `roadmap-run.mjs` (retired) | ravintio-zero |
| Stage prefix | The label at the start of an initiative stage message, from `I-A Chart:` to `I-E Delivery:`. The letters name stages, not phase numbers. | `R-A` to `R-E` (retired) | ravintio-zero |
| Migration 0005 | The consumer migration that renames a draft's `roadmap.md` to `initiative.md` and the CI pattern to `initiative/**`. It stops while `plan/current-roadmap/` exists. | Migration `0005` | ravintio-zero |
| Old-name allowlist | The exact paths that the old-name search test accepts with an old name. The only folder entries are `plan/_archive/` and `plan/changelog/`. | Allowlist | ravintio-zero |
