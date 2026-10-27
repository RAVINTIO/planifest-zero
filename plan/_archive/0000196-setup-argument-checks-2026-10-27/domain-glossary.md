---
title: "Domain Glossary - setup argument checks"
summary: "Definitions of terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - setup argument checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Version:** 0.20.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Retired flag | A setup flag that an earlier release removed. It does nothing. | removed flag | ravintio-zero |
| Tool | The agent host that setup installs for. The only valid tool is `claude-code`. | harness | ravintio-zero |
| Rejected run | A setup run that exits 1 during argument checks. It changes no file. | none | ravintio-zero |
| Setup record | The tracked file `plan/state/{tool}.md` that lists the flags in use. | flags record | ravintio-zero |
| Setup marker | The file `{tool-dir}/.ravintio-setup-flags` that setup writes at install time. | flags marker | ravintio-zero |
