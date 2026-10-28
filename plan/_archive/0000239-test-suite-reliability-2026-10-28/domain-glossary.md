---
title: "Domain Glossary - test suite reliability"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - test suite reliability

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Version:** 0.30.2

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Assert helper | A function in `helpers/assert.sh` whose name starts with `assert_` | assertion | ravintio-zero |
| Installed copy | A file under `.claude/skills/`, written by setup | runtime sync copy | ravintio-zero |
| Stale install | An installed copy older than the newest pack skill | lagging copy | ravintio-zero |
