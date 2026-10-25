---
title: "Domain Glossary - release-hygiene"
summary: "Definitions of the terms used in the PR attribution check and the release-tag job."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - release-hygiene

**Skill:** plan
**Feature:** 0000169-release-hygiene
**Version:** 0.14.0

> The ubiquitous language for this feature. If the glossary says "PR description", the code and docs say "PR description", not "PR body" or "PR text". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Attribution line | A line in a commit message or PR description that credits an AI tool. The ban names `Generated with [Claude Code]`, `Co-Authored-By:`, and `Claude-Session:` lines. | AI attribution line, host line | ravintio-zero |
| Host | The AI coding tool that writes attribution lines. In this feature, the host is Claude Code. | None | ravintio-zero |
| PR description | The text body of a pull request. CI passes it to the check through an environment variable. The check never prints it. | PR body | ravintio-zero |
| Release tag | A git tag named `v{version}`, where `{version}` comes from `product.yml`, falling back to `docs/about.md`. The `release-tag` job puts it on the commit that a push to `main` delivers. | None | ravintio-zero |
| Squash merge | A merge that leaves the branch's own commits off `main`. | None | ravintio-zero |
| Consumer repo | A repo that installs the RAVINTIO Zero pack by copying its folder and running setup. | Consumer | ravintio-zero |
