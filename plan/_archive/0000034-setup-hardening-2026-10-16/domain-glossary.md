---
title: "Domain Glossary - setup-hardening"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.4.1"
---
# Domain Glossary - setup-hardening

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000034-setup-hardening
**Version:** 0.4.1

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition |
|------|-----------|
| Retired flag | A setup flag that an earlier release removed. Setup now accepts it with a warning and ignores it. This feature has four. |
| Unknown flag | Any argument starting with `-` that is neither a current flag nor a retired flag. Setup exits 1 on it. |
| Flags marker | `.claude/.planifest-setup-flags`, the JSON file setup writes with the flags it ran with. `planifest-refresh-setup` replays it. |
| Setup record | `plan/state/{tool}.md`, the tracked copy of the active flags (0000032). |
| Atomic write | Writing `settings.json.planifest-tmp` in the same folder, then renaming it over `settings.json`, so the file is always whole. |
| Temporary file | `settings.json.planifest-tmp`, the file an atomic write writes first. |
