---
title: "Domain Glossary - merge-guard block message"
summary: "Definitions of terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - merge-guard block message

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000197-merge-guard-block-message
**Version:** 0.20.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Tripwire | The raw-text check that sends a command to the strict parser when it holds merge words. | wire | ravintio-zero |
| Segment | One piece of a command after the hook splits it at `&&`, `\|\|`, `;`, `&`, `\|`, and line breaks. | none | ravintio-zero |
| Bare merge call | A segment that is a plain `gh pr merge` with no quoting, substitution, variable, or wrapper. | plain call | ravintio-zero |
| Merge words in text | Merge words inside a segment that is not a bare merge call, such as a heredoc line. | none | ravintio-zero |
