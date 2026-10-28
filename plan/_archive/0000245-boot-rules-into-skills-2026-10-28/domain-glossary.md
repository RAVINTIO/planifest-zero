---
title: "Domain Glossary - boot rules into skills"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - boot rules into skills

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Version:** 0.34.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Override | A Markdown file in `ravintio-overrides/instructions/` that adds a repo rule | custom instruction | ravintio-zero |
| Targeted override | An override whose frontmatter holds `target: {skill}` | none | ravintio-zero |
| Boot file | The generated `CLAUDE.md` or `AGENTS.md` that every session loads | boot template output | ravintio-zero |
| Capability skill | A repo skill in `ravintio-overrides/capability-skills/` that setup installs | repo skill | ravintio-zero |
| Hook Enforcement reference | `ravintio-zero/standards/hook-enforcement.md`, the list of hooks and what each does | none | ravintio-zero |
