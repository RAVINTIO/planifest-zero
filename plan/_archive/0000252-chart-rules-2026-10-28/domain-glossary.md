---
title: "Domain Glossary - chart rules"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - chart rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000252-chart-rules
**Version:** 0.40.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Guard | A fail-closed hook, such as `merge-guard`, `gate-write`, or `ratchet-check` | fail-closed hook | ravintio-zero |
| Widening | A change that lets a guard pass a form that it blocks today | none | ravintio-zero |
| Step confirmation | A point where a skill that a step loads asks the human to confirm, such as Step 4 of `ravintio-refresh-setup` | none | ravintio-zero |
| P1 skip row | A row in the `## P1 skips` table of `initiative.md` that says whether a step may skip P1 | none | ravintio-zero |
