---
title: "Domain Glossary - ship merge command and wall clock check"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - ship merge command and wall clock check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Version:** 0.37.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Phase block | A `### P<n>: {Phase Name}` heading and its field table in the build log | block | ravintio-zero |
| Wall clock | The whole minutes from a block's `Start` to its `End` | none | ravintio-zero |
| Skipped-phase line | A build log line `Skipped: P{n}` that excuses a missing phase block | none | ravintio-zero |
| Plain merge line | The one-line `gh pr merge --squash --delete-branch {n}` with a literal PR number | none | ravintio-zero |
