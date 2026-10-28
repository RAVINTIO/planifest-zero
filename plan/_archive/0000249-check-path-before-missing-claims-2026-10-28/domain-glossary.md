---
title: "Domain Glossary - PATH check before a missing-program claim"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - PATH check before a missing-program claim

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000249-check-path-before-missing-claims
**Version:** 0.38.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| PATH check | A `command -v {program}` search, followed by a look in the common install folders, before a report says a program is missing | none | ravintio-zero |
| Docs-only claim | A claim about behaviour that rests on documentation and that no run has observed | none | ravintio-zero |
| `unverified (docs only)` | The outcome for a docs-only claim. It never counts as `verified` | none | ravintio-zero |
