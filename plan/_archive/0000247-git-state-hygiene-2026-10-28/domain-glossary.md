---
title: "Domain Glossary - git state hygiene"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - git state hygiene

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Version:** 0.36.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Id reservation | A block of ids taken from the counter file `plan/backlog/.next-id` | reservation | ravintio-zero |
| Queued entry | A backlog entry the initiative skill writes while the driver runs | none | ravintio-zero |
| Parallel batch | Subagents dispatched in one message that share one working tree | fast batch | ravintio-zero |
