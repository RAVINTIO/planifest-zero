---
title: "Domain Glossary - size cap excludes overrides"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - size cap excludes overrides

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Version:** 0.31.2

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Override block | The text between the `ravintio-overrides:instructions` markers in `CLAUDE.md` | override section | ravintio-zero |
| Pack-only measure | The byte size of `CLAUDE.md` with the override block removed | none | ravintio-zero |
| Combined cap | The limit on `SKILL.md` bytes plus the pack-only measure | size cap | ravintio-zero |
