---
title: "Domain Glossary - explain-strict-mode"
summary: "Definitions of the strict mode terms used in this feature."
status: "draft"
version: "0.18.1"
---
# Domain Glossary - explain-strict-mode

**Skill:** plan
**Feature:** 0000185-explain-strict-mode
**Version:** 0.18.1

> The ubiquitous language for this feature. Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Strict mode | A setup option that makes each session prove it loaded the orchestrator. The `--strict-orchestrator` flag turns it on. | Strict orchestrator mode | ravintio-zero |
| `plan/.orchestrator-strict` | The marker file that turns strict mode on. Setup writes it when you pass `--strict-orchestrator`. | Strict marker | ravintio-zero |
| `plan/.orchestrator-ack` | A one-line file that holds the id of the session that last loaded the orchestrator. The name is short for acknowledgement. | Ack file, session acknowledgement | ravintio-zero |
| Session id | The id that Claude Code passes to each hook. The hook compares it with the ack file. | `session_id` | ravintio-zero |
| Strict mode banner | The `RAVINTIO STRICT MODE` message the hook prints when the ack file does not match. It asks the agent to load the orchestrator. | Hard-block banner | ravintio-zero |
