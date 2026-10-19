---
title: "Domain Glossary - setup-hook-filter-fixes"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.5.1"
---
# Domain Glossary - setup-hook-filter-fixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000038-setup-hook-filter-fixes
**Version:** 0.5.1

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| hook entry | One item in an event array of `.claude/settings.json`. It holds a `hooks` array of hook commands. | entry | planifest-zero |
| hook command | One command object inside a hook entry's `hooks` array. | command | planifest-zero |
| Planifest command | A hook command that runs a Planifest module of its event at a path boundary. Setup may remove it. | Planifest hook | planifest-zero |
| user command | A hook command that is not a Planifest command. Setup must keep it. | user hook | planifest-zero |
| path-boundary match | The case-sensitive test that a command runs `<module>.mjs` with a path separator or the start of the string before the module name. A substring alone does not match (0000035 S-004). | boundary match | planifest-zero |
| per-command filter | The rule that setup removes Planifest commands from a hook entry one at a time. It keeps the entry if user commands remain and drops it if none remain. | | planifest-zero |
| planted entry | A test fixture hook entry written into a `settings.json` before setup runs, to check what setup keeps or removes. | | planifest-zero |
| parity | The property that `setup.sh` and `setup.ps1` produce the same entries from the same input (0000035 ADR-001). | | planifest-zero |
