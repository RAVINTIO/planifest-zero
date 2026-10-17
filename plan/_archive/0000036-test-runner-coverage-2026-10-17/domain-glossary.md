---
title: "Domain Glossary - test-runner-coverage"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.4.3"
---
# Domain Glossary - test-runner-coverage

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000036-test-runner-coverage
**Version:** 0.4.3

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition |
|------|-----------|
| Suite | A `test-*.sh` or `test-*.ps1` file directly in `tests/` or `tests/regression/`. The runner runs each one. |
| Known non-suite | A file the runner expects and doesn't run, such as `README.md` or a helper. The design lists them. |
| Stray file | Any other file under `tests/`. The runner names it and fails the run. |
| Host | The PowerShell program running a suite. It is `powershell` (Windows PowerShell 5.1) or `pwsh` (PowerShell 7). |
| Manifest | `tests/regression/regression-manifest.json`, the list of promoted regression suites. |
