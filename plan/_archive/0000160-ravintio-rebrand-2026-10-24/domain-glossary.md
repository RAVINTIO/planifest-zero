---
title: "Domain Glossary - ravintio-rebrand"
summary: "Definitions of the terms used in the RAVINTIO Zero rebrand."
status: "active"
version: "1.0.0"
---
# Domain Glossary - ravintio-rebrand

**Skill:** plan
**Feature:** 0000160-ravintio-rebrand
**Version:** 1.0.0

> Casing rule: prose writes the brand in block caps as RAVINTIO. Identifiers use lowercase `ravintio`. Environment variables use `RAVINTIO_`. OTEL labels use `ravintio.`.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| RAVINTIO | The brand of the product family. Prose writes it in block caps. | Planifest (retired) | ravintio-zero |
| RAVINTIO Zero | The drop-in, confirmed-design pipeline pack. It replaces Planifest Zero. | Planifest Zero (retired) | ravintio-zero |
| RAVINTIO Framework | The sibling product that replaces Planifest Framework. It lives in its own repo. | Planifest Framework (retired) | ravintio-zero |
| pack | The `ravintio-zero/` folder. Consumers copy it into a repo and run setup. | planifest-zero folder (retired) | ravintio-zero |
| consumer | A repo that has installed the pack. | user repo, adopter | ravintio-zero |
| overrides folder | The `ravintio-overrides/` folder. It holds a consumer's own instructions and survives pack upgrades. | planifest-overrides (retired) | ravintio-zero |
| legacy alias | An old name that 1.x still accepts. The two `PLANIFEST_ROADMAP_*` variables and the `planifest-em-dash-allow` sentinel are the only ones. | fallback | ravintio-zero |
| brand guard | The test that fails when "planifest" appears in a tracked file outside history and the allowlist. | guard test | ravintio-zero |
| migration helper | A Bash or PowerShell script that a migration runs. `migrate-ravintio-rename.sh` and `.ps1` are the helpers for migration 0004. | migration script | ravintio-zero |
| history folders | `plan/_archive/`, `plan/changelog/`, and `ravintio-zero/migrations/_done/`. They keep the old name as written. | history records | ravintio-zero |
