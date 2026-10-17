---
title: "Domain Glossary - self-host-on-planifest-zero"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.5.0"
---
# Domain Glossary - self-host-on-planifest-zero

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000037-self-host-on-planifest-zero
**Version:** 0.5.0

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Old framework copy | `planifest-framework/`, the older framework folder this repo runs its own pipeline on. req-004 deletes it. | old folder | repo level |
| `planifest-zero/` | The shipped framework. After req-004, this run reads each `planifest-framework/{path}` from `planifest-zero/{path}`. | shipped framework | `planifest-zero` |
| Setup record | The file setup writes to record the tool and flags in effect. This repo keeps it at `plan/state/claude-code.md`, with a `flags` array and a `writtenAt` time. | flags-used marker | `planifest-zero`, repo level |
| Retired flag | A setup flag the product no longer supports, such as `--structured-telemetry-mcp`. Setup warns on it and installs nothing for it. | none | `planifest-zero`, repo level |
| Rename suite | The suite that fails while any live file still names `planifest-framework/`. It checks cases (a) to (e). | none | `planifest-zero` |
| Five-phase pipeline | The pipeline that `planifest-zero/` ships. The next feature runs on it after the deferred reinstall. | none | `planifest-zero` |
| Standard-iterative mode | The adoption mode for a repo with prior runs, detected from `plan/_archive/` and `docs/about.md`. | none | `planifest-zero` |
| Planifest hook entry | An entry in `settings.json` that runs a Planifest hook module, such as `gate-write`. Setup matches it by module name, whatever its matcher. | none | `planifest-zero` |
| Non-array hook event | A `PreToolUse` or `UserPromptSubmit` value in `settings.json` that isn't an array, often from a hand edit. Setup warns and replaces it with the Planifest entries. | none | `planifest-zero` |
| Suite | A `test-*.sh` or `test-*.ps1` file that `run-tests.sh` runs. | none | `planifest-zero` |
