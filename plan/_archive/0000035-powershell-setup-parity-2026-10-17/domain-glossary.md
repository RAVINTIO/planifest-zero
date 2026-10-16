---
title: "Domain Glossary - powershell-setup-parity"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.4.2"
---
# Domain Glossary - powershell-setup-parity

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000035-powershell-setup-parity
**Version:** 0.4.2

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition |
|------|-----------|
| Enforcement hook | One of six Node modules setup wires into `.claude/settings.json`. They are `gate-write`, `ratchet-check`, `em-dash-guard`, `auto-trigger-orchestrator`, `check-orchestrator-presence`, and `check-design`. |
| Hook parity | Both setup scripts wire the same hook modules, in the same events, matchers, and order. |
| Event value | The value under one key of `hooks` in `settings.json`, such as `hooks.PreToolUse`. It is normally an array of entries. |
| Temporary file | `settings.json.planifest-tmp`, the file an atomic write writes first (0000034 ADR-002). |
| Leftover | A temporary file that a hard stop left behind. |
