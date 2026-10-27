# Domain Glossary - Codex support

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Harness | The agent program that runs a model with tools, such as Claude Code or Codex. | agent harness | ravintio-zero |
| Tool target | A harness that setup can install for. Its config lives in `setup/{tool}.sh` and `setup/{tool}.ps1`. | tool | ravintio-zero |
| Boot file | The file a harness loads at session start. It is `CLAUDE.md` for Claude Code and `AGENTS.md` for Codex. | none | ravintio-zero |
| Active hook | An enforcement hook that setup wires into the harness. | none | ravintio-zero |
| Fallback hook | An enforcement rule that setup can't wire for a harness. The boot file states it as an instruction. | none | ravintio-zero |
