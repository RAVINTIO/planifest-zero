---
title: "Domain Glossary - setup-hardening-release-sizing"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.6.0"
---
# Domain Glossary - setup-hardening-release-sizing

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000039-setup-hardening-release-sizing
**Version:** 0.6.0

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| hook entry | One item in an event array of `.claude/settings.json`. It holds a `hooks` value of hook commands. | entry | planifest-zero |
| `hooks` value | The `hooks` field of a hook entry. It is normally an array of hook commands. | | planifest-zero |
| single-object `hooks` value | A `hooks` value that is one command object instead of an array. Setup treats it as a one-item array. | | planifest-zero |
| hook command | One command object inside a hook entry's `hooks` value. | command | planifest-zero |
| Planifest command | A hook command that runs a Planifest module of its event at a path boundary. Setup may remove it. | Planifest hook | planifest-zero |
| user command | A hook command that is not a Planifest command. Setup must keep it. | user hook | planifest-zero |
| path-boundary match | The case-sensitive test that a command runs `<module>.mjs` with a path separator or the start of the string before the module name. A substring alone does not match (0000035 S-004). | boundary match | planifest-zero |
| per-command filter | The rule that setup removes Planifest commands from a hook entry one at a time. It keeps the entry if user commands remain and drops it if none remain (0000038). | | planifest-zero |
| invalid JSON | A `settings.json` that fails to parse. Setup prints one fixed line that names the file, leaves the file unchanged, and exits 1. | | planifest-zero |
| planted value | A test fixture value written into a `settings.json` before setup runs, to check that it never appears in stdout or stderr. | | planifest-zero |
| parity | The property that `setup.sh` and `setup.ps1` produce the same result from the same input (0000035 ADR-001). | | planifest-zero |
| `releaseSize` | The optional `product.yml` field that sets the release budget. Its values are `small`, `medium`, and `large`. The default is `medium`. | release-size setting | planifest-zero |
| release size | The total points that discovery fills into one release. | | planifest-zero |
| size class | The class discovery gives a candidate from its estimated file count: S (1 to 2 files), M (3 to 6 files), or L (7 or more files). | class | planifest-zero |
| point | The unit of a size class. S is 1 point, M is 2, and L is 4. | | planifest-zero |
| budget | The most points one release may hold. It is 4 for `small`, 8 for `medium`, and 14 for `large`. | | planifest-zero |
| fill | The set of candidates that discovery recommends for a release, up to the budget. The human confirms it. Above the budget, discovery recommends a split. | | planifest-zero |
